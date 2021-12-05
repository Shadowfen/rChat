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
function rChat.getPlayerNames()
	local names={}
	for i = 1, GetNumCharacters() do
		local name, _, _, _, _, _, characterId = GetCharacterInfo(i)
		table.insert(names, zo_strformat("<<1>>", name))
	end
	return names
end
function rChat.getPlayerIds()
	local ids={}
	for i = 1, GetNumCharacters() do
		local name, _, _, _, _, _, characterId = GetCharacterInfo(i)
		table.insert(ids, characterId)
	end
	return ids
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
    local segment
    while doCut do

        fromWithUTFShift = UTFAdditionalBytes
        UTFAdditionalBytes = 0

        splitEnd = splitStart + maxChars - 1
        if(splitEnd >= text_len) then
            splitEnd = text_len
            doCut = false
        elseif (string.byte(text, splitEnd, splitEnd)) > 128 then
            UTFAdditionalBytes = 1

            local lastByte = string.byte(segment, -1)

            if lastByte >= 128 and lastByte < 192 then
                splitEnd = splitEnd + UTFAdditionalBytes
                local beforeLastByte = string.byte(segment, -2, -2)
                segment = text:sub(splitStart, splitEnd)

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

-- Split text into blocs of 100 chars (106 is max for LinkHandle) and add LinkHandle to them
function rChat.SplitTextForLinkHandler(text, numLine, chanCode)

    if not text then return nil end

    local newText = ""
    local textLen = string.len(text)
    local MAX_LEN = 100

	if textLen <= MAX_LEN then
	    -- No need to split down to size
        newText = text
        if not (text == " " or text == ": ") then
            newText = rChat.LinkHandler_CreateLink(numLine, chanCode, text, true)
        end
		return newText
	end
	
-- ABNF from RFC 3629
--
-- UTF8-octets = *( UTF8-char )
-- UTF8-char = UTF8-1 / UTF8-2 / UTF8-3 / UTF8-4
-- UTF8-1 = %x00-7F
-- UTF8-2 = %xC2-DF UTF8-tail
-- UTF8-3 = %xE0 %xA0-BF UTF8-tail / %xE1-EC 2( UTF8-tail ) /
-- %xED %x80-9F UTF8-tail / %xEE-EF 2( UTF8-tail )
-- UTF8-4 = %xF0 %x90-BF 2( UTF8-tail ) / %xF1-F3 3( UTF8-tail ) /
-- %xF4 %x80-8F 2( UTF8-tail )
-- UTF8-tail = %x80-BF
--
	-- we got here so string is too long, must split
    -- LinkHandle does not handle text > 106 chars, so we need to split

	local splitStart = 1
	local count = 1
	--local needToSplit = true
	local leftover = textLen % MAX_LEN
	local maxsplits = (textLen - leftover)/MAX_LEN + 2
	while maxsplits do
		maxsplits = maxsplits - 1
		
		local segment = ""
		local UTFAditionalBytes = 0

		if textLen > (count * MAX_LEN) then

			local splitEnd = splitStart + MAX_LEN
			segment = text:sub(splitStart, splitEnd) -- We can "cut" characters by doing this
			if segment == "" then 
				-- we've run out of string, exit the loop
				if newText == "" then
					newText = text
				end
				break 
			end
			
			local lastByte = string.byte(segment, -1)
			local beforeLastByte = string.byte(segment, -2, -2)

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
				segment = text:sub(splitStart, splitEnd)

			elseif lastByte >= 192 and lastByte < 224 then 
				-- last byte = 1st byte of a 2 Byte character. We take 1 byte more.  (cut was incorrect)
				UTFAditionalBytes = 1
				splitEnd = splitEnd + UTFAditionalBytes
				segment = text:sub(splitStart, splitEnd)
				
			elseif lastByte >= 224 and lastByte < 240 then 
				-- last byte = 1st byte of a 3 Byte character. We take 2 byte more.  (cut was incorrect)
				UTFAditionalBytes = 2
				splitEnd = splitEnd + UTFAditionalBytes
				segment = text:sub(splitStart, splitEnd)
			end

			splitStart = splitEnd + 1
			newText = newText .. rChat.LinkHandler_CreateLink(numLine, chanCode, segment, true)
			count = count + 1

		else
			segment = text:sub(splitStart)
			local textSplittedlen = segment:len()
			if textSplittedlen > 0 then
				newText = newText .. rChat.LinkHandler_CreateLink(numLine, chanCode, segment, true)
			end
			--needToSplit = false
			break
		end

	end

    return newText

end
--[[
-- returns the number of bytes used by the UTF-8 character at byte i in s
-- also doubles as a UTF-8 character validator
local function utf8charbytes (s, i)
	-- argument defaults
	i = i or 1

	-- argument checking
	if type(s) ~= "string" then
		error("bad argument #1 to 'utf8charbytes' (string expected, got ".. type(s).. ")")
	end
	if type(i) ~= "number" then
		error("bad argument #2 to 'utf8charbytes' (number expected, got ".. type(i).. ")")
	end

	local c = byte(s, i)

	-- determine bytes needed for character, based on RFC 3629
	-- validate byte 1
	if c > 0 and c <= 127 then
		-- UTF8-1
		return 1

	elseif c >= 194 and c <= 223 then
		-- UTF8-2
		local c2 = byte(s, i + 1)

		if not c2 then
			error("UTF-8 string terminated early")
		end

		-- validate byte 2
		if c2 < 128 or c2 > 191 then
			error("Invalid UTF-8 character")
		end

		return 2

	elseif c >= 224 and c <= 239 then
		-- UTF8-3
		local c2 = byte(s, i + 1)
		local c3 = byte(s, i + 2)

		if not c2 or not c3 then
			error("UTF-8 string terminated early")
		end

		-- validate byte 2
		if c == 224 and (c2 < 160 or c2 > 191) then
			error("Invalid UTF-8 character")
		elseif c == 237 and (c2 < 128 or c2 > 159) then
			error("Invalid UTF-8 character")
		elseif c2 < 128 or c2 > 191 then
			error("Invalid UTF-8 character")
		end

		-- validate byte 3
		if c3 < 128 or c3 > 191 then
			error("Invalid UTF-8 character")
		end

		return 3

	elseif c >= 240 and c <= 244 then
		-- UTF8-4
		local c2 = byte(s, i + 1)
		local c3 = byte(s, i + 2)
		local c4 = byte(s, i + 3)

		if not c2 or not c3 or not c4 then
			error("UTF-8 string terminated early")
		end

		-- validate byte 2
		if c == 240 and (c2 < 144 or c2 > 191) then
			error("Invalid UTF-8 character")
		elseif c == 244 and (c2 < 128 or c2 > 143) then
			error("Invalid UTF-8 character")
		elseif c2 < 128 or c2 > 191 then
			error("Invalid UTF-8 character")
		end
		
		-- validate byte 3
		if c3 < 128 or c3 > 191 then
			error("Invalid UTF-8 character")
		end

		-- validate byte 4
		if c4 < 128 or c4 > 191 then
			error("Invalid UTF-8 character")
		end

		return 4

	else
		error("Invalid UTF-8 character")
	end
end
--]]