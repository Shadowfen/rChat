local MAX_HISTORY_LENGTH = 5000
local TRIMMED_HISTORY_LENGTH = 4000
local HRS_TO_SEC = 3600

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





-- ------------------------------------------------------
-- old
rChat_history = {
    LineStrings = {
        -- rawFrom,         the sender of the message (not really raw)
        -- rawMessage,      the text of the message
        -- rawLine,         includes timestamp, from, channel, message, etc
        -- channel,         the channel that the message was on
        -- rawTimestamp,    the timestamp string
        -- timestamp,       the timestamp epoch (number)
        -- rawDisplayed,    what actually gets printed to the chat window
        -- rawValue,
    }
}

local RH = rChat_history

function RH.ChatLine()
    return {}
end

function RH:GetLine(lineNumber)
    return self.LineStrings[lineNumber]
end

function RH:SaveLine(line)
    table.insert(self.LineStrings,line)
end

function RH:GetSize()
    return #self.LineStrings
end

function RH:GarbageCollect(typeOfExit, timeBeforeRestore, restoreSystem, restoreSystemOnly, restoreWhispers)

    local function removeLine(index)
        table.remove(self.LineStrings, index)
        index = index-1
        return index
    end

    -- First loop is time based. If message is older than our limit, it will be stripped.
    local curtime= GetTimeStamp()
    local k = 1
    while k <= #self.LineStrings do

        if self.LineStrings[k] then
            local channel = self.LineStrings[k].channel
            if channel == CHAT_CHANNEL_SYSTEM and (not restoreSystem) then
                k = removeLine(k)
            elseif channel ~= CHAT_CHANNEL_SYSTEM and restoreSystemOnly then
                k = removeLine(k)
            elseif (channel == CHAT_CHANNEL_WHISPER or channel == CHAT_CHANNEL_WHISPER_SENT)
                    and (not restoreWhispers) then
                k = removeLine(k)
            elseif typeOfExit ~= 1 and self.LineStrings[k].rawTimestamp then
                if (curtime - self.LineStrings[k].rawTimestamp) > (timeBeforeRestore * 60 * 60) then
                    k = removeLine(k)
                elseif self.LineStrings[k].rawTimestamp > curtime then
                    -- System clock of users computer badly set and msg received meanwhile.
                    k = removeLine(k)
                end
            end
        end

        k = k + 1

    end

    -- 2nd loop is size based. If dump is too big, just delete old ones
    local maxLines = 5000
    if #self.LineStrings > maxLines then
        local linesToDelete = #self.LineStrings - maxLines
        for l=1, linesToDelete do
            -- yes, always delete the first line of the table if it exists
            if self.LineStrings[1] then
                removeLine(1)
            end
        end
    end

end
