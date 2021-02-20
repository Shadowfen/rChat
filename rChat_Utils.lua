rChat = rChat or {}

local SF = LibSFUtils

-- Used for rChat LinkHandling
local RCHAT_LINK = "p"
local RCHAT_URL_CHAN = 97
local RCHAT_CHANNEL_NONE = 99

-- ------------------------------------------------------
-- Guild functions

-- does not return nil for name! - if bad then return nil guildId
function rChat.SafeGetGuildName(index)

    -- Guildname
    local guildId = GetGuildId(index)
    if not guildId then 
        return ("Invalid guild " .. index),nil
    end
    local guildName = GetGuildName(guildId)

    -- Occurs sometimes
    if(not guildName or (guildName):len() < 1) then
        guildName = "Guild " .. guildId
    end
    return guildName, guildId
end

-- ------------------------------------------------------
-- Timestamp functions
--

-- Create a timestamp string in the specified format
-- with the time string (HH:mm:ss) provided. If no time
-- is provided then get the current time.
function rChat.CreateTimestamp(formatStr, timeStr)
    if not timeStr then timeStr = GetTimeString() end

    -- split up default timestamp
    local hours, minutes, seconds = timeStr:match("([^%:]+):([^%:]+):([^%:]+)")
    local hoursNoLead = tonumber(hours) -- hours without leading zero
    local hours12NoLead = (hoursNoLead - 1)%12 + 1
    local hours12 = hours12NoLead
    if (hours12NoLead < 10) then
        hours12 = "0" .. hours12NoLead
    end
    local pUp = "AM"
    local pLow = "am"
    if (hoursNoLead >= 12) then
        pUp = "PM"
        pLow = "pm"
    end

    -- create new one
    local timestamp = formatStr
    timestamp = timestamp:gsub("HH", hours)
    timestamp = timestamp:gsub("H", hoursNoLead)
    timestamp = timestamp:gsub("hh", hours12)
    timestamp = timestamp:gsub("h", hours12NoLead)
    timestamp = timestamp:gsub("m", minutes)
    timestamp = timestamp:gsub("s", seconds)
    timestamp = timestamp:gsub("A", pUp)
    timestamp = timestamp:gsub("a", pLow)

    return timestamp

end


-- split a string into an array of strings, each no longer than
-- maxChars bytes.
-- courtesy of LibOrangUtils, modified to handle multibyte characters
function rChat.strSplitMB(text, maxChars)

    local retval = {}
    local text_len = string.len(text)
    if(text_len <= maxChars) then
        -- no need to split
        retval[#retval+1] = text
        return retval
    end

    -- original text too long, must split
    local UTFAdditionalBytes = 0
    local fromWithUTFShift  = 0
    local doCut = true
    local splitStart = 0
    local splitEnd
    local splitString
    while doCut do

        fromWithUTFShift = UTFAdditionalBytes
        UTFAdditionalBytes = 0

        splitEnd = splitStart + maxChars - 1
        if(splitEnd >= text_len) then
            splitEnd = text_len
            doCut = false
        elseif (string.byte(text, splitEnd, splitEnd)) > 128 then
            UTFAdditionalBytes = 1

            local lastByte = string.byte(splitString, -1)

            if lastByte >= 128 and lastByte < 192 then
                splitEnd = splitEnd + UTFAdditionalBytes
                local beforeLastByte = string.byte(splitString, -2, -2)
                splitString = text:sub(splitStart, splitEnd)

                if beforeLastByte >= 224 and beforeLastByte < 240 then
                    UTFAdditionalBytes = 1
                end

            elseif lastByte >= 192 and lastByte < 224 then
                UTFAdditionalBytes = 1
                splitEnd = splitEnd + UTFAdditionalBytes

            elseif lastByte >= 224 and lastByte < 240 then
                UTFAdditionalBytes = 2
                splitEnd = splitEnd + UTFAdditionalBytes
            end
        end

        retval[#retval+1] = string.sub(text, splitStart, splitEnd)
        splitStart = splitEnd + 1
    end


    return retval

end

-- Create an RCHAT link of the passed in text with chanCode, numline data.
-- withoutbrackets (boolean) is optional - defaults to false.
function rChat.LinkHandler_CreateLink(numLine, chanCode, text, withoutbrackets)
    if not withoutbrackets then
        return ZO_LinkHandler_CreateLink(text, nil, RCHAT_LINK, numLine, chanCode)
    else
        return ZO_LinkHandler_CreateLinkWithoutBrackets(text, nil, RCHAT_LINK, numLine, chanCode)
    end
end

-- Split text with blocs of 100 chars (106 is max for LinkHandle) and add LinkHandle to them
function rChat.SplitTextForLinkHandler(text, numLine, chanCode)

    if not text then return nil end

    local newText = ""
    local textLen = string.len(text)
    local MAX_LEN = 100

    -- LinkHandle does not handle text > 106 chars, so we need to split
    if textLen > MAX_LEN then

        local splitStart = 1
        local splits = 1
        local needToSplit = true

        while needToSplit do

            local splitString = ""
            local UTFAditionalBytes = 0

            if textLen > (splits * MAX_LEN) then

                local splitEnd = splitStart + MAX_LEN
                splitString = text:sub(splitStart, splitEnd) -- We can "cut" characters by doing this
				if splitString == "" then 
					if newText == "" then
						return text
					end
					return newText 
				end
                local lastByte = string.byte(splitString, -1)
                local beforeLastByte = string.byte(splitString, -2, -2)

                -- Characters can be into 1, 2 or 3 bytes. Lua don't support UTF natively. We only handle 3 bytes chars.
                -- http://www.utf8-chartable.de/unicode-utf8-table.pl

                if (lastByte < 128) then -- any ansi character (ex : a  97  LATIN SMALL LETTER A) (cut was well made)
                    --
                elseif lastByte >= 128 and lastByte < 192 then
                    -- any non ansi character ends with last byte = 128-191  (cut was well made)
                    -- or 2nd byte of a 3 Byte character. We take 1 byte more.  (cut was incorrect)

                    if beforeLastByte >= 192 and beforeLastByte < 224 then
                        -- "2 latin characters" ex: 195 169  LATIN SMALL LETTER E WITH ACUTE ;
                        -- е 208 181 CYRILLIC SMALL LETTER IE
                        --
                    elseif beforeLastByte >= 128 and beforeLastByte < 192 then
                        -- "3 Bytes Cyrillic & Japanese" ex U+3057  し   227 129 151 HIRAGANA LETTER SI
                        --
                    elseif beforeLastByte >= 224 and beforeLastByte < 240 then
                        -- 2nd byte of a 3 Byte character. We take 1 byte more.  (cut was incorrect)
                        UTFAditionalBytes = 1
                    end

                    splitEnd = splitEnd + UTFAditionalBytes
                    splitString = text:sub(splitStart, splitEnd)

                elseif lastByte >= 192 and lastByte < 224 then 
                    -- last byte = 1st byte of a 2 Byte character. We take 1 byte more.  (cut was incorrect)
                    UTFAditionalBytes = 1
                    splitEnd = splitEnd + UTFAditionalBytes
                    splitString = text:sub(splitStart, splitEnd)
					
                elseif lastByte >= 224 and lastByte < 240 then 
                    -- last byte = 1st byte of a 3 Byte character. We take 2 byte more.  (cut was incorrect)
                    UTFAditionalBytes = 2
                    splitEnd = splitEnd + UTFAditionalBytes
                    splitString = text:sub(splitStart, splitEnd)
                end

                splitStart = splitEnd + 1
                newText = newText .. rChat.LinkHandler_CreateLink(numLine, chanCode, splitString, true)
                splits = splits + 1

            else
                splitString = text:sub(splitStart)
                local textSplittedlen = splitString:len()
                if textSplittedlen > 0 then
                    newText = newText .. rChat.LinkHandler_CreateLink(numLine, chanCode, splitString, true)
                end
                needToSplit = false
            end

        end
    else
        -- When dumping back, the "from" section is sent here. It will add handler to spaces.
        -- prevent it to avoid an unneeded increase of the message.
        newText = text
        if not (text == " " or text == ": ") then
            newText = rChat.LinkHandler_CreateLink(numLine, chanCode, text, true)
        end
    end

    return newText

end

