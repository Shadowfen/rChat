local MAX_HISTORY_LENGTH = 5000
local TRIMMED_HISTORY_LENGTH = 4000
local HRS_TO_SEC = 3600

---------------------------------------------------------
-- NO LONGER IN USE
-- ------------------------------------------------------
-- LineStrings functions
--

-- get the number of entries saved in the chat cache
function rChat.getChatCacheSize()
    local db = rChat.save
    if db.LineStrings == nil then return 0 end
    if db.lineNumber == nil or db.lineNumber == 1 then return 0 end
    return db.lineNumber - 1
end

-- only returns an entry for previously written entries, nil otherwise
function rChat.getCacheEntry(line)
    local db = rChat.save
    if db.LineStrings == nil then return nil end
    if not line or line <= 1 then return nil end
    return db.LineStrings[line]
end

-- Returns reference to a new entry for populating
-- (and increments line count in cache)
function rChat.getNewCacheEntry(channel)
    local db = rChat.save
    if db.LineStrings == nil then
        db.LineStrings = {}
    end
    if not db.lineNumber or db.lineNumber <= 1 then
        db.lineNumber = #db.LineStrings + 1
    end
    local lineno = db.lineNumber
    db.lineNumber = db.lineNumber + 1
    db.LineStrings[lineno] = {
        rawFrom = "",
        rawMessage = "",
        rawLine = "",
        rawValue = "",
        rawDisplayed = "",
        rawTimestamp = "",
        timestamp = GetTimeStamp(),
        channel = channel,
    }
    return db.LineStrings[lineno], lineno
end

-- iterator function to iterate through the chat cache
function rChat.iterCache()
    local db = rChat.save
    return ipairs(db.LineStrings)
end

-- empty and reset the cache
function rChat.clearCache()
    rChat.save.LineStrings = {}
    rChat.save.lineNumber = 1
end

-- set the specified index with a new entry table
-- (populated correctly). Returns the index that
-- the entry was added into (since index is an
-- optional parameter that defaults to the end of
-- the cache if not specified).
function rChat.SetLine(entry, index)
    local db = rChat.save
    if not index then
        index = db.lineNumber
        db.lineNumber = db.lineNumber + 1
    end
    db.LineStrings[index] = entry
    return index
end

-- initialize cache if none was saved
function rChat.initCache()
    local db = rChat.save
    if not db.LineStrings then
        db.LineStrings = {}
        db.lineNumber = 1
        return      -- don't need to prune
    end
    if not db.lineNumber or type(db.lineNumber) ~= "number" then
        db.lineNumber = #db.LineStrings + 1
    end
end




