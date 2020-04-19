rChatData = {
    name = "rChatData",
    
    cache = {},
    cmds = {},
}

local MAX_HISTORY_LENGTH = 5000
local TRIMMED_HISTORY_LENGTH = 4000
local HRS_TO_SEC = 3600

local cache
local cmds

-- ------------------------------------------------------
-- Entries functions
--

-- get the number of entries saved in the chat cache
function rChatData.getChatCacheSize()
    if cache.Entries == nil then return 0 end
    if cache.lineNumber == nil or cache.lineNumber == 1 then return 0 end
    return cache.lineNumber - 1
end

-- only returns an entry for previously written entries, nil otherwise
function rChatData.getCacheEntry(linenum)
    if cache.Entries == nil then return nil, 0 end
    if not linenum or linenum < 1 then return nil, 0 end
    if linenum >= cache.lineNumber then return nil, 0 end
    return cache.Entries[linenum], linenum
end

-- Returns reference to a new entry for populating
-- (and increments line count in cache)
function rChatData.getNewCacheEntry(channel)
    if cache.Entries == nil then
        cache.Entries = {}
    end
    if not cache.lineNumber or cache.lineNumber <= 1 then
        cache.lineNumber = #cache.Entries + 1
    end
    local lineno = cache.lineNumber
    cache.lineNumber = cache.lineNumber + 1
    cache.Entries[lineno] = {
        rawFrom = "",
        rawMessage = "",
        rawLine = "",
        rawValue = "",
        displayed = "",
        rawTimestamp = "",
        timestamp = GetTimeStamp(),
        channel = channel,
    }
    return cache.Entries[lineno], lineno
end

-- iterator function to iterate through the chat cache
function rChatData.iterCache()
    return ipairs(cache.Entries)
end

-- empty and reset the cache
function rChatData.clearCache()
    cache.Entries = {}
    cache.lineNumber = 1
end

-- set the specified index with a new entry table
-- (populated correctly). Returns the index that
-- the entry was added into (since index is an
-- optional parameter that defaults to the end of
-- the cache if not specified).
-- If an entry for index already exists it will be overwritten.
function rChatData.SetLine(entry, index)
    if not index then
        index = cache.lineNumber
        cache.lineNumber = cache.lineNumber + 1
    end
    cache.Entries[index] = entry
    return index
end

-- Truncate overflow entries from a table 
-- Specifying maxage is optional
function rChatData.truncate(tbl, maxlen, trunclen, maxage)
    local tmptbl = {}
    if #tbl >= maxlen or maxage then
        local currentTime= GetTimeStamp()
        local start = #tbl - trunclen + 1
        if start < 1 then start = 1 end
        for i = start, #tbl do
            if maxage then 
                if tbl[i].timestamp then
                    if tbl[i].timestamp > maxage  then
                        if tbl[i].timestamp > currentTime + 60 then
                            -- adjust misaligned clock?
                            tbl[i].timestamp = currentTime
                        end
                        table.insert(tmptbl, tbl[i])  -- still young enough
                    end
                else
                    table.insert(tmptbl, tbl[i])  -- without a timestamp we cannot age
                end
            else
                table.insert(tmptbl, tbl[i]) -- no maxage, so we cannot age-check
            end
        end
        tbl = tmptbl
    end
    return tbl, #tbl
end
    
-- initialize cache if none was saved
function rChatData.initCache(maxage)
    if not rChatData.cache then
        rChatData.cache = { Entries = {}, lineNumber = 1, }
    end
    if not cache then cache = rChatData.cache end
    if not cache.Entries then
        cache.Entries = {}
        cache.lineNumber = 1
        return      -- don't need to prune
    end
    if not cache.lineNumber or type(cache.lineNumber) ~= "number" then
        cache.lineNumber = #cache.Entries + 1
    end
    
    -- prune if necessary
    cache.Entries = rChatData.truncate(cache.Entries, MAX_HISTORY_LENGTH, TRIMMED_HISTORY_LENGTH, maxage)
    cache.lineNumber = #cache.Entries + 1
end

-- Load data from saved variables 
local function OnDataLoaded(_, addonName)

    --Protect
    if addonName ~= "rChatData" then return end
    
    local cacheDefault = {
        Entries = {},
        lineNumber = 1,
    }

    -- Saved variables
    rChatData.cache = ZO_SavedVars:NewAccountWide("RCHAT_CACHE", 1, GetWorldName(), cacheDefault)
    cache = rChatData.cache
    
    rChatData.cmds = ZO_SavedVars:NewAccountWide("RCHAT_CMDS", 1, GetWorldName(), {})
    cmds = rChatData.cmds
end

EVENT_MANAGER:RegisterForEvent("rChatData", EVENT_ADD_ON_LOADED, OnDataLoaded)

-- ------------------------------------------------------
--[[ old
rChat_history = {
    Entries = {
        -- channel,         the channel that the message was on
        -- timestamp,       the timestamp epoch (number)
        -- rawFrom,         the sender of the message (not really raw)
        -- rawMessage,      the text of the message
        -- rawLine,         includes timestamp, from, channel, message, etc
        -- rawTimestamp,    the timestamp string
        -- displayed,    what actually gets printed to the chat window
        -- rawValue,
    }
}

--]]


