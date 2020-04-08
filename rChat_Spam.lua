rChat = rChat or {}

local SF = LibSFUtils

-- the spam table from the saved variables
local config = {}
function rChat.setSpamConfig(cfgtable)
    config = cfgtable or {}
end

local spammableChannels = {
    [CHAT_CHANNEL_ZONE_LANGUAGE_1 + 1] = true,
    [CHAT_CHANNEL_ZONE_LANGUAGE_2 + 1] = true,
    [CHAT_CHANNEL_ZONE_LANGUAGE_3 + 1] = true,
    [CHAT_CHANNEL_ZONE_LANGUAGE_4 + 1] = true,
    [CHAT_CHANNEL_SAY + 1] = true,
    [CHAT_CHANNEL_YELL + 1] = true,
    [CHAT_CHANNEL_ZONE + 1] = true,
    [CHAT_CHANNEL_EMOTE + 1] = true,
}

local function IsSpammableChannel(chanCode)
    if chanCode == nil or chanCode == 0 then return nil end
    return spammableChannels[chanCode + 1]
end

-- Return true/false if text is a flood
local function SpamFlood(from, text, spamChanCode)
    local db = rChat.save

    -- 2+ messages identical in less than 30 seconds on Character channels = spam
    local previousLine = rChat.getChatCacheSize()
    if previousLine == 0 then return false end
    local ourMessageTimestamp = GetTimeStamp()

    local checkSpam = true
    while checkSpam do
        local entry = rChat.getCacheEntry(previousLine)
        -- Previous line can be a ChanSystem one
        if entry and entry.channel ~= CHAT_CHANNEL_SYSTEM then
            if (type(entry.rawTimestamp) == "number") and
                    ((ourMessageTimestamp - entry.rawTimestamp) < config.floodGracePeriod) then
                -- if our message is sent by our chatter / will be break by "Character" channels and "UserID" Channels
                if from == entry.rawFrom then
                    -- if our message is eq of last message
                    if text == entry.rawText then
                        -- Previous and current must be in zone(s), yell, say, emote (Character Channels except party)
                        if IsSpammableChannel(spamChanCode) and IsSpammableChannel(entry.channel) then
                            -- Spam
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
            return true

        -- Werewolf Bite
        elseif string.find(text, "[Ww][Ww][%s]+[Bb][Ii][Tt][Ee]") then
            -- Match
            return true

        -- Crowns
        elseif string.find(text, "[Cc][Rr][Oo][Ww][Nn][Ss]") then
            -- Match
            return true

        end

    end

    return false

end

-- Return true/false if text is a Guild recruitment one
local function SpamGuildRecruit(text)

    -- look for guild link in message
    local validLinkTypes = {
        [GUILD_LINK_TYPE] = true,
    }
    local linksTable = {}     -- returned
    ZO_ExtractLinksFromText(text, validLinkTypes, linksTable)
    if next(linksTable) ~= nil then
        return true
    end
    return false

end

-- Return true/false if anti spam is enabled for a certain category
-- Categories must be : Flood, LookingFor, WantTo, GuildRecruit
local function IsSpamEnabledForCategory(category)
    local rChatData = rChat.data

    if category == "Flood" then

        -- Enabled in Options?
        if config.floodProtect then
            -- AntiSpam is enabled
            return true
        end

        -- AntiSpam is disabled
        return false

    -- LFG
    elseif category == "LookingFor" then
        -- Enabled in Options?
        if config.lookingForProtect then
            -- Enabled in reality?
            if rChatData.spamLookingForEnabled then
                -- AntiSpam is enabled
                return true
            else
                -- AntiSpam is disabled .. since -/+ grace time ?
                if GetTimeStamp() - rChatData.spamTempLookingForStopTimestamp > (config.spamGracePeriod * 60) then
                    -- Grace period outdatted -> we need to re-enable it
                    rChatData.spamLookingForEnabled = true
                    return true
                end
            end
        end

        -- AntiSpam is disabled
        return false

    -- WTT
    elseif category == "WantTo" then
        -- Enabled in Options?
        if config.wantToProtect then
            -- Enabled in reality?
            if rChatData.spamWantToEnabled then
                -- AntiSpam is enabled
                return true
            else
                -- AntiSpam is disabled .. since -/+ grace time ?
                if GetTimeStamp() - rChatData.spamTempWantToStopTimestamp > (config.spamGracePeriod * 60) then
                    -- Grace period outdatted -> we need to re-enable it
                    rChatData.spamWantToEnabled = true
                    return true
                end
            end
        end

        -- AntiSpam is disabled
        return false

    -- Join my Awesome guild
    elseif category == "GuildRecruit" then
        -- Enabled in Options?
        if config.guildProtect then
            -- Enabled in reality?
            if rChatData.spamGuildRecruitEnabled then
                -- AntiSpam is enabled
                return true
            else
                -- AntiSpam is disabled .. since -/+ grace time ?
                if GetTimeStamp() - rChatData.spamTempGuildRecruitStopTimestamp > (config.spamGracePeriod * 60) then
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
            return true
        end
    end

    -- But "I" can have other exceptions (useful for testing)
    local isMe = false
    if zo_strformat(SI_UNIT_NAME, from) == GetUnitName("player") or from == GetDisplayName() then
        -- I'm allowed to do spammable things
        isMe = true
    end

    -- Looking For
    if IsSpamEnabledForCategory("LookingFor") then
        if SpamLookingFor(text) then
            if isMe == false then
                return true
            else
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
                return true
            else
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
                return true
            else
                rChatData.spamTempGuildRecruitStopTimestamp = GetTimeStamp()
                rChatData.spamGuildRecruitStop = true
                return false
            end
        end
    end

    return false

end
