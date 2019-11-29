rChat = rChat or {}

local SF = LibSFUtils

-- These require access to rChat.save and rChat.data (local vars in rChat.lua that have
-- been stuffed in rChat table so that we can get to them from here.
-- Readdress this properly.

local spammableChannels = {}
spammableChannels[CHAT_CHANNEL_ZONE_LANGUAGE_1 + 1] = true
spammableChannels[CHAT_CHANNEL_ZONE_LANGUAGE_2 + 1] = true
spammableChannels[CHAT_CHANNEL_ZONE_LANGUAGE_3 + 1] = true
spammableChannels[CHAT_CHANNEL_ZONE_LANGUAGE_4 + 1] = true
spammableChannels[CHAT_CHANNEL_SAY + 1] = true
spammableChannels[CHAT_CHANNEL_YELL + 1] = true
spammableChannels[CHAT_CHANNEL_ZONE + 1] = true
spammableChannels[CHAT_CHANNEL_EMOTE + 1] = true

local function IsSpammableChannel(chanCode)
    if chanCode == nil then return nil end
    return spammableChannels[chanCode + 1]
end

-- Return true/false if text is a flood
local function SpamFlood(from, text, chanCode)
    local db = rChat.save

    -- 2+ messages identical in less than 30 seconds on Character channels = spam
        
    -- Should not happen
    if db.LineStrings == nil then return false end
    if db.lineNumber == nil or db.lineNumber == 1 then return false end   -- 1st message cannot be a spam
        
    
    local previousLine = db.lineNumber - 1
    local ourMessageTimestamp = GetTimeStamp()
    
    local checkSpam = true
    while checkSpam do
        
        -- Previous line can be a ChanSystem one
        if db.LineStrings[previousLine].channel ~= CHAT_CHANNEL_SYSTEM then
            if (ourMessageTimestamp - db.LineStrings[previousLine].rawTimestamp) < db.floodGracePeriod then
                -- if our message is sent by our chatter / will be break by "Character" channels and "UserID" Channels
                if from == db.LineStrings[previousLine].rawFrom then
                    -- if our message is eq of last message
                    if text == db.LineStrings[previousLine].rawText then
                        -- Previous and current must be in zone(s), yell, say, emote (Character Channels except party)
                        if IsSpammableChannel(spamChanCode) and IsSpammableChannel(db.LineStrings[previousLine].channel) then
                            -- Spam
                            --CHAT_SYSTEM:Zo_AddMessage("Spam detected ( " .. text ..  " )")
                            return true
                        end
                    end
                end
            else
                -- > 30s, stop analysis
                checkSpam = false
            end
        end
        
        if previousLine > 1 then
            previousLine = previousLine - 1
        else
            checkSpam = false
        end
    
    end
    
    return false
        
end

-- Return true/false if text is a LFG message
local function SpamLookingFor(text)

    local spamStrings = {
        [1] = "l[%s.]?f[%s.]?[%d]?[%s.]?[mg]",  -- (m)ember, (g)roup
        [2] = "l[%s.]?f[%s.]?[%d]?[%s.]?heal", -- heal
        [3] = "l[%s.]?f[%s.]?[%d]?[%s.]?dd",    -- dd
        [4] = "l[%s.]?f[%s.]?[%d]?[%s.]?dps",    -- dps
        [5] = "l[%s.]?f[%s.]?[%d]?[%s.]?tank", -- tank
        [6] = "l[%s.]?f[%s.]?[%d]?[%s.]?daily", -- daily
        [7] = "l[%s.]?f[%s.]?[%d]?[%s.]?dungeon", -- dungeon
    }
    local lowertext = string.lower(text)
    for _, spamString in ipairs(spamStrings) do
        if string.find(lowertext, spamString) then
            --CHAT_SYSTEM:Zo_AddMessage("spamLookingFor:" .. text .." ;spamString=" .. spamString)
            return true
        end
    end

    return false

end

-- Return true/false if text is a WTT message
local function SpamWantTo(text)

    -- "W.T S"
    if string.find(text, "[wW][%s.]?[tT][%s.]?[bBsStT]") then -- buy, sell, trade
        
        -- Item Handler
        if string.find(text, "|H(.-):item:(.-)|h(.-)|h") then
            -- Match
            --CHAT_SYSTEM:Zo_AddMessage("WT detected ( " .. text .. " )")
            return true
            
        -- Werewolf Bite
        elseif string.find(text, "[Ww][Ww][%s]+[Bb][Ii][Tt][Ee]") then
            -- Match
            --CHAT_SYSTEM:Zo_AddMessage("WT WW Bite detected ( " .. text .. " )")
            return true
            
        -- Crowns
        elseif string.find(text, "[Cc][Rr][Oo][Ww][Nn][Ss]") then
            -- Match
            --CHAT_SYSTEM:Zo_AddMessage("WT Crowns detected ( " .. text .. " )")
            return true
            
        end
    
    end
    
    return false
    
end

-- Return true/false if text is a Guild recruitment one
local function SpamGuildRecruit(text)


    -- look for guild link in message
    validLinkTypes = {
        [GUILD_LINK_TYPE] = true,
    }
    linksTable = {}     -- returned
    --CHAT_SYSTEM:Zo_AddMessage("Looking for guild link")
    ZO_ExtractLinksFromText(text, validLinkTypes, linksTable)
    if next(linksTable) ~= nil then
        --CHAT_SYSTEM:Zo_AddMessage("Found guild link "..guildHeuristics)
        return true
    end
    return false
    
end

-- Return true/false if anti spam is enabled for a certain category
-- Categories must be : Flood, LookingFor, WantTo, GuildRecruit
local function IsSpamEnabledForCategory(category)
    local db = rChat.save
    local rChatData = rChat.data
    
    if category == "Flood" then
    
        -- Enabled in Options?
        if db.floodProtect then
            --CHAT_SYSTEM:Zo_AddMessage("floodProtect enabled")
            -- AntiSpam is enabled
            return true
        end
        
        --CHAT_SYSTEM:Zo_AddMessage("floodProtect disabled")
        -- AntiSpam is disabled
        return false
    
    -- LFG
    elseif category == "LookingFor" then
        -- Enabled in Options?
        if db.lookingForProtect then
            -- Enabled in reality?
            if rChatData.spamLookingForEnabled then
                --CHAT_SYSTEM:Zo_AddMessage("lookingForProtect enabled")
                -- AntiSpam is enabled
                return true
            else
            
                --CHAT_SYSTEM:Zo_AddMessage("lookingForProtect is temporary disabled since " .. rChat.spamTempLookingForStopTimestamp)
                
                -- AntiSpam is disabled .. since -/+ grace time ?
                if GetTimeStamp() - rChatData.spamTempLookingForStopTimestamp > (db.spamGracePeriod * 60) then
                    --CHAT_SYSTEM:Zo_AddMessage("lookingForProtect enabled again")
                    -- Grace period outdatted -> we need to re-enable it
                    rChatData.spamLookingForEnabled = true
                    return true
                end
            end
        end
        
        --CHAT_SYSTEM:Zo_AddMessage("lookingForProtect disabled")
        -- AntiSpam is disabled
        return false
    
    -- WTT
    elseif category == "WantTo" then
        -- Enabled in Options?
        if db.wantToProtect then
            -- Enabled in reality?
            if rChatData.spamWantToEnabled then
                --CHAT_SYSTEM:Zo_AddMessage("wantToProtect enabled")
                -- AntiSpam is enabled
                return true
            else
                -- AntiSpam is disabled .. since -/+ grace time ?
                if GetTimeStamp() - rChatData.spamTempWantToStopTimestamp > (db.spamGracePeriod * 60) then
                    --CHAT_SYSTEM:Zo_AddMessage("wantToProtect enabled again")
                    -- Grace period outdatted -> we need to re-enable it
                    rChatData.spamWantToEnabled = true
                    return true
                end
            end
        end
        
        --CHAT_SYSTEM:Zo_AddMessage("wantToProtect disabled")
        -- AntiSpam is disabled
        return false
    
    -- Join my Awesome guild
    elseif category == "GuildRecruit" then
        -- Enabled in Options?
        if db.guildProtect then
            -- Enabled in reality?
            if rChatData.spamGuildRecruitEnabled then
                -- AntiSpam is enabled
                return true
            else
                -- AntiSpam is disabled .. since -/+ grace time ?
                if GetTimeStamp() - rChatData.spamTempGuildRecruitStopTimestamp > (db.spamGracePeriod * 60) then
                    -- Grace period outdated -> we need to re-enable it
                    rChatData.spamGuildRecruitEnabled = true
                    return true
                end
            end
        end
        
        -- AntiSpam is disabled
        return false
    
    end
    
end

-- Return true is message is a spam depending on MANY parameters
function rChat.SpamFilter(chanCode, from, text, isCS)

    -- ZOS GM are NEVER blocked
    if isCS then return false end
    
    if not IsSpammableChannel(chanCode) then return false end
    
    local rChatData = rChat.data

    -- 4 options for spam : Spam flood (multiple messages) ; LFM/LFG ; WT(T/S/B) ; Guild Recruitment
    
    -- Spam (I'm not allowed to flood even for testing)
    if IsSpamEnabledForCategory("Flood") then
        if SpamFlood(from, text, chanCode) then 
            --CHAT_SYSTEM:Zo_AddMessage("Blocked flood 1")
            return true 
        end
    end
    
    -- But "I" can have other exceptions (useful for testing)
    local isMe = false
    if zo_strformat(SI_UNIT_NAME, from) == rChatData.localPlayer or from == GetDisplayName() then
        -- I'm allowed to do spammable things
        isMe = true
        --CHAT_SYSTEM:Zo_AddMessage("I saw something ( " .. text .. " )")
    end

    -- Looking For
    if IsSpamEnabledForCategory("LookingFor") then
        if SpamLookingFor(text) then 
            if isMe == false then
                --CHAT_SYSTEM:Zo_AddMessage("Blocked LFG 1")
                return true 
            else
                --CHAT_SYSTEM:Zo_AddMessage("I saw a LF Message ( " .. text .. " )")
                rChatData.spamTempLookingForStopTimestamp = GetTimeStamp()
                rChatData.spamLookingForEnabled = false
                return false 
            end
        end

    end
    
    -- Want To
    if IsSpamEnabledForCategory("WantTo") then
        if SpamWantTo(text) then 
            if isMe == false then
                --CHAT_SYSTEM:Zo_AddMessage("Blocked WTT 1")
                return true 
            else
                --CHAT_SYSTEM:Zo_AddMessage("I saw a WT Message ( " .. text .. " )")
                rChatData.spamTempWantToStopTimestamp = GetTimeStamp()
                rChatData.spamWantToStop = true
                return false 
            end
        end
    end
    
    -- Guild Recruit
    if IsSpamEnabledForCategory("GuildRecruit") then
        if SpamGuildRecruit(text, chanCode) then  
            if isMe == false then
                --CHAT_SYSTEM:Zo_AddMessage("Blocked GR 1")
                return true 
            else
                --CHAT_SYSTEM:Zo_AddMessage("I saw a GR Message ( " .. text .. " )")
                rChatData.spamTempGuildRecruitStopTimestamp = GetTimeStamp()
                rChatData.spamGuildRecruitStop = true
                return false 
            end
        end
    end
    
    return false

end
