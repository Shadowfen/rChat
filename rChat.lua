-- Registering libraries
local LAM = LibAddonMenu2
local LMP = LibMediaProvider
local SF = LibSFUtils
local RAM = rChat.AutoMsg

local L = GetString

local CACHE = rChatData

local HRS_TO_SEC = 3600

-- Init
local isAddonLoaded         = false -- OnAddonLoaded() done

-- ---- Mention specific options
local defmention = {
	mentionEnabled = false,
	mentionStr = "",
    colorizedMention = "",
	soundEnabled = false,
	sound = SOUNDS.NEW_NOTIFICATION,
	colorEnabled = false,
	color = "|cFFFFFF",
}

-- ---- Anti Spam specific options
local defspam = {
    spamGracePeriod = 5,
    floodProtect = true,
    floodGracePeriod = 30,
    lookingForProtect = false,
    wantToProtect = false,
    guildProtect = false,
}

-- Default variables to push in SavedVars
local defaults = {
	mention = defmention,
    spam = defspam,

    -- ---- Message Settings
    allZonesSameColour = true,
    allNPCSameColour = true,
    delzonetags = true,
    carriageReturn = false,
    useESOcolors = true,
    diffforESOcolors = 40,
    showTagInEntry = true,
    geoChannelsFormat = 2,
    disableBrackets = true,
    addChannelAndTargetToHistory = true,
    urlHandling = true,
    nicknames = "",
    -- ---- Message Settings - End

    -- ---- Timestamp Settings
    showTimestamp = true,
    timestampcolorislcol = false,
    timestampFormat = "HH:m",
    -- colors["timestamp"],
    -- ---- Timestamp Settings - End

    -- ---- Guild Settings
    showGuildNumbers = false,
    allGuildsSameColour = false,
    guildTags = {},
    officertag = {},
    switchFor = {},
    officerSwitchFor = {},
    formatguild = {},
    -- color[] stuff here too
    -- ---- Guild Settings - End

    -- ---- Chat Tab Settings
    enableChatTabChannel = true,
    defaultchannel = CHAT_CHANNEL_GUILD_1,
    defaultTab = 1,
    defaultTabName = "",
    -- ---- Chat Tab Settings - End

    -- ---- Whisper Settings
    whispsoundEnabled = false,
    soundforincwhisps = SOUNDS.NEW_NOTIFICATION,
    notifyIM = false,
    -- ---- Whisper Settings

    -- ---- Group Settings
    enablepartyswitch = true,
    groupLeader = false,
    -- colours["groupleader"]
    -- colours["groupleader1"]
    groupNames = 1,
    -- ---- Group Settings - End

    -- ---- Chat Window Settings specific options
    windowDarkness = 6,
    alwaysShowChat = false,
    augmentHistoryBuffer = true,
    oneColour = false,
    chatMinimizedAtLaunch = false,
    chatMinimizedInMenus = false,
    chatMaximizedAfterMenus = false,
    fonts = "ESO Standard Font",
    enablecopy = true,
    -- colours["tabwarning"],
    -- ---- Chat Window Settings specific options - End

    -- ---- Restore Options
    restoreOnReloadUI = true,
    restoreOnLogOut = true,
    restoreOnAFK = true,        -- kicked
    timeBeforeRestore = 2,
    restoreOnQuit = false,
    restoreSystem = true,
    restoreSystemOnly = false,
    restoreWhisps = true,
    restoreTextEntryHistoryAtLogOutQuit = false,
    -- ---- Restore Options - End

    -- ---- Sync Settings
    chatSyncConfig = true,
    -- localPlayer
    chatConfSync = {},  -- not LAM
    -- ---- Sync Settings - End

    -- ----
    newcolors = {
        -- player colors
        [CHAT_CHANNEL_SAY] = {"|cFFFFFF", "|cFFFFFF",},  -- say
        [CHAT_CHANNEL_YELL] = {"|cE974D8", "|cFFB5F4",},  -- yell
        [CHAT_CHANNEL_WHISPER] = {"|cB27BFF", "|cB27BFF",},  -- whisper
        [CHAT_CHANNEL_WHISPER_SENT] = {"|c7E57B5", "|c7E57B5",},  -- whisper out
        [CHAT_CHANNEL_PARTY] = {"|c6EABCA", "|cA1DAF7",},  -- group
        [CHAT_CHANNEL_EMOTE] = {"|cA5A5A5", "|cA5A5A5",},  -- emote

        -- npc colors
        [CHAT_CHANNEL_MONSTER_SAY] = {"|c879B7D", "|c879B7D",},  -- npc say
        [CHAT_CHANNEL_MONSTER_YELL] = {"|c879B7D", "|c879B7D",},  -- npc yell
        [CHAT_CHANNEL_MONSTER_WHISPER] = {"|c879B7D", "|c879B7D",},  -- npc whisper
        [CHAT_CHANNEL_MONSTER_EMOTE] = {"|c879B7D", "|c879B7D",},  -- npc emote

        -- guild colors
        [CHAT_CHANNEL_GUILD_1] = {"|c94E193", "|cC3F0C2",},  -- guild
        [CHAT_CHANNEL_GUILD_2] = {"|c94E193", "|cC3F0C2",},
        [CHAT_CHANNEL_GUILD_3] = {"|c94E193", "|cC3F0C2",},
        [CHAT_CHANNEL_GUILD_4] = {"|c94E193", "|cC3F0C2",},
        [CHAT_CHANNEL_GUILD_5] = {"|c94E193", "|cC3F0C2",},
        [CHAT_CHANNEL_OFFICER_1] = {"|cC3F0C2", "|cC3F0C2",},  -- guild officers
        [CHAT_CHANNEL_OFFICER_2] = {"|cC3F0C2", "|cC3F0C2",},
        [CHAT_CHANNEL_OFFICER_3] = {"|cC3F0C2", "|cC3F0C2",},
        [CHAT_CHANNEL_OFFICER_4] = {"|cC3F0C2", "|cC3F0C2",},
        [CHAT_CHANNEL_OFFICER_5] = {"|cC3F0C2", "|cC3F0C2",},

        -- other colors (zone)
        [CHAT_CHANNEL_ZONE] = {"|cCEB36F", "|cB0A074",},
        [CHAT_CHANNEL_ZONE_LANGUAGE_1] = {"|cCEB36F", "|cB0A074",},  -- EN zone
        [CHAT_CHANNEL_ZONE_LANGUAGE_2] = {"|cCEB36F", "|cB0A074",},  -- FR zone
        [CHAT_CHANNEL_ZONE_LANGUAGE_3] = {"|cCEB36F", "|cB0A074",},  -- DE zone
        [CHAT_CHANNEL_ZONE_LANGUAGE_4] = {"|cCEB36F", "|cB0A074",},  -- JP zone
    },
    colours = {
        -- misc
        ["timestamp"] = "|c8F8F8F", -- timestamp
        ["tabwarning"] = "|c76BCC3", -- tab Warning ~ "Azure" (ZOS default)
        ["groupleader"] = "|cC35582", --
        ["groupleader1"] = "|c76BCC3", --
    },
}

-- used by convertSavedColors() for saved variable color conversion 
-- between addon versions
local coloredChannels  = {
    CHAT_CATEGORY_SAY,
    CHAT_CATEGORY_YELL,
    CHAT_CATEGORY_WHISPER,
    CHAT_CATEGORY_WHISPER_SENT,
    CHAT_CATEGORY_ZONE,
    CHAT_CATEGORY_PARTY,
    CHAT_CATEGORY_EMOTE,
    CHAT_CATEGORY_SYSTEM,
    CHAT_CATEGORY_GUILD_1,
    CHAT_CATEGORY_GUILD_2,
    CHAT_CATEGORY_GUILD_3,
    CHAT_CATEGORY_GUILD_4,
    CHAT_CATEGORY_GUILD_5,
    CHAT_CATEGORY_OFFICER_1,
    CHAT_CATEGORY_OFFICER_2,
    CHAT_CATEGORY_OFFICER_3,
    CHAT_CATEGORY_OFFICER_4,
    CHAT_CATEGORY_OFFICER_5,
    CHAT_CATEGORY_ZONE_ENGLISH,     -- LANGUAGE_1
    CHAT_CATEGORY_ZONE_FRENCH,     -- LANGUAGE_2
    CHAT_CATEGORY_ZONE_GERMAN,     -- LANGUAGE_3
    CHAT_CATEGORY_ZONE_JAPANESE,     -- LANGUAGE_4
    CHAT_CATEGORY_MONSTER_SAY,
    CHAT_CATEGORY_MONSTER_YELL,
    CHAT_CATEGORY_MONSTER_WHISPER,
    CHAT_CATEGORY_MONSTER_EMOTE,
}
-- SV
local db
local targetToWhisp


-- rData will receive variables and objects.
local rData = rChat.data

-- Used for rChat LinkHandling
local RCHAT_LINK = "p"
local RCHAT_URL_CHAN = 97
local RCHAT_CHANNEL_NONE = 99

-- Save AddMessage for internal debug - AVOID DOING A CHAT_SYSTEM:AddMessage() in rChat, it can cause recursive calls
CHAT_SYSTEM.Zo_AddMessage = CHAT_SYSTEM.AddMessage

-- used only by save and sync chat config
rData.chatCategories = {
    CHAT_CATEGORY_SAY,
    CHAT_CATEGORY_YELL,
    CHAT_CATEGORY_WHISPER_INCOMING,
    CHAT_CATEGORY_WHISPER_OUTGOING,
    CHAT_CATEGORY_ZONE,
    CHAT_CATEGORY_PARTY,
    CHAT_CATEGORY_EMOTE,
    CHAT_CATEGORY_SYSTEM,
    CHAT_CATEGORY_GUILD_1,
    CHAT_CATEGORY_GUILD_2,
    CHAT_CATEGORY_GUILD_3,
    CHAT_CATEGORY_GUILD_4,
    CHAT_CATEGORY_GUILD_5,
    CHAT_CATEGORY_OFFICER_1,
    CHAT_CATEGORY_OFFICER_2,
    CHAT_CATEGORY_OFFICER_3,
    CHAT_CATEGORY_OFFICER_4,
    CHAT_CATEGORY_OFFICER_5,
    CHAT_CATEGORY_ZONE_ENGLISH,
    CHAT_CATEGORY_ZONE_FRENCH,
    CHAT_CATEGORY_ZONE_GERMAN,
    CHAT_CATEGORY_ZONE_JAPANESE,
    CHAT_CATEGORY_MONSTER_SAY,
    CHAT_CATEGORY_MONSTER_YELL,
    CHAT_CATEGORY_MONSTER_WHISPER,
    CHAT_CATEGORY_MONSTER_EMOTE,
}

-- used only in savetabcategories
rData.guildCategories = {
    CHAT_CATEGORY_GUILD_1,
    CHAT_CATEGORY_GUILD_2,
    CHAT_CATEGORY_GUILD_3,
    CHAT_CATEGORY_GUILD_4,
    CHAT_CATEGORY_GUILD_5,
    CHAT_CATEGORY_OFFICER_1,
    CHAT_CATEGORY_OFFICER_2,
    CHAT_CATEGORY_OFFICER_3,
    CHAT_CATEGORY_OFFICER_4,
    CHAT_CATEGORY_OFFICER_5,
}

local chatStrings_brackets = {
    standard = "%s%s: |r%s%s%s|r", -- standard format: say, yell, group, npc, npc yell, npc whisper, zone
    esostandard = "%s%s %s: |r%s%s%s|r", -- standard format: say, yell, group, npc, npc yell, npc whisper, zone with tag (except for monsters)
    esoparty = "%s%s%s: |r%s%s%s|r", -- standard format: party
    tellIn = "%s%s: |r%s%s%s|r", -- tell in
    tellOut = "%s-> %s: |r%s%s%s|r", -- tell out
    emote = "%s%s |r%s%s|r", -- emote
    guild = "%s%s %s: |r%s%s%s|r", -- guild
    language = "%s[%s] %s: |r%s%s%s|r", -- language zones

    -- For copy System, only Handle "From part"

    copystandard = "[%s]: ", -- standard format: say, yell, group, npc, npc yell, npc whisper, zone
    copyesostandard = "[%s] %s: ", -- standard format: say, yell, group, npc, npc yell, npc whisper, zone with tag (except for monsters)
    copyesoparty = "[%s]%s: ", -- standard format: party
    copytellIn = "[%s]: ", -- tell in
    copytellOut = "-> [%s]: ", -- tell out
    copyemote = "%s ", -- emote
    copyguild = "[%s] [%s]: ", -- guild
    copylanguage = "[%s] %s: ", -- language zones
    copynpc = "%s: ", -- NPCs
}

local chatStrings_nobrackets = {
    standard = chatStrings_brackets.standard,
    esostandard = chatStrings_brackets.esostandard,
    esoparty = chatStrings_brackets.esoparty,
    tellIn = chatStrings_brackets.tellIn,
    tellOut = chatStrings_brackets.tellOut,
    emote = chatStrings_brackets.emote,
    guild = chatStrings_brackets.guild,
    language = chatStrings_brackets.language,

    -- For copy System, only Handle "From part"
    copystandard = "%s: ", -- standard format: say, yell, group, npc, npc yell, npc whisper, zone
    copyesostandard = "%s %s: ", -- standard format: say, yell, group, npc, npc yell, npc whisper, zone with tag (except for monsters)
    copyesoparty = "[%s]%s: ", -- standard format: party
    copytellIn = "%s: ", -- tell in
    copytellOut = "-> %s: ", -- tell out
    copyemote = chatStrings_brackets.copyemote,
    copyguild = "[%s] %s: ", -- guild
    copylanguage = chatStrings_brackets.copylanguage,
    copynpc = chatStrings_brackets.copynpc,
}

local chatStrings = chatStrings_brackets

local MENU_CATEGORY_RCHAT = nil

-- get a color (hex) pair from the chat colors table (indexed by channel id)
function rChat.getColors(channelId)
    local colorsEntry = db.newcolors[channelId]
    if not colorsEntry then
        colorsEntry = db.newcolors[1]
    end
    return colorsEntry[1], colorsEntry[2]    -- left, right
end

function rChat.setLeftColor(channelId, r, g, b)
    local colorsEntry = db.newcolors[channelId]
    colorsEntry[1] = rChat.ConvertRGBToHex(r, g, b)
end

function rChat.setRightColor(channelId, r, g, b)
    local colorsEntry = db.newcolors[channelId]
    colorsEntry[2] = rChat.ConvertRGBToHex(r, g, b)
end

local function getLeftColorRGB(channelId)
    local colorsEntry = db.newcolors[channelId]
    return rChat.ConvertHexToRGBA(colorsEntry[1])
end

local function getRightColorRGB(channelId)
    local colorsEntry = db.newcolors[channelId]
    return rChat.ConvertHexToRGBA(colorsEntry[2])
end


-------------------------------------------------------
-- return the index of the guild associated with the channel
-- that was passed in. If the channel is not associated with a
-- guild, then return 0.
local function GetGuildIndex(channel)
    local index = 0
    local isOfc = false
    if channel >= CHAT_CHANNEL_GUILD_1 and channel <= CHAT_CHANNEL_OFFICER_5 then
        index = channel - CHAT_CHANNEL_GUILD_1 + 1
    elseif channel >= CHAT_CHANNEL_OFFICER_1 and channel <= CHAT_CHANNEL_OFFICER_5 then
        index = channel - CHAT_CHANNEL_OFFICER_1 + 1
        isOfc = true
    end
    return index
end

-- return the guild channel and guild officer channel for
-- a particular guild index
local function GetGuildChannel(index)
    local mem, ofc
    mem = CHAT_CHANNEL_GUILD_1 - 1 + index
    ofc = CHAT_CHANNEL_OFFICER_1 - 1 + index
    return mem, ofc
end

-- Strip all of the color markers out of the
-- provided text, returning what is left.
--
local function stripColours(text)
        -- get positions of all of the desired delimiters
    local t1 = SF.getAllColorDelim(text)

    if #t1 == 0 then
        -- no delimiters in string
        return text
    end

    -- remove color markers
    return SF.stripColors(t1, text)
end

-- Format "From" name
local function ConvertName(chanCode, from, isCS, fromDisplayName)

    local function GetNameLink(realFrom, displayed, linkType)
        if not displayed then -- Should not happen, maybe parser error with nicknames.
            displayed = realFrom
        end
        local linkedFrom
        if db.disableBrackets then
            linkedFrom = ZO_LinkHandler_CreateLinkWithoutBrackets(displayed, nil, linkType, realFrom)
        else
            linkedFrom = ZO_LinkHandler_CreateLink(displayed, nil, linkType, realFrom)
        end
        return linkedFrom, displayed
    end

    -- "From" can be UserID or Character name depending on which channel we are
    local new_from = from
    local displayed = from

    -- Messages from @Someone (guild / whisps)
    if IsDecoratedDisplayName(from) then

        local guildIndex = GetGuildIndex(chanCode)
        if guildIndex > 0 then  -- Guild / Officer chat only

            -- Get guild ID based on channel id
            local guildName,guildId = rChat.SafeGetGuildName(guildIndex)
            if guildId then
                if rData.nicknames[new_from] then -- @UserID Nicknamed
                    new_from, displayed = GetNameLink(new_from, rData.nicknames[new_from], DISPLAY_NAME_LINK_TYPE)

                elseif db.formatguild[guildName] == 2 then -- Char
                    local _, characterName = GetGuildMemberCharacterInfo(guildId, GetGuildMemberIndexFromDisplayName(guildId, new_from))
                    characterName = zo_strformat(SI_UNIT_NAME, characterName)
                    local nickNamedName
                    if rData.nicknames[characterName] then -- Char Nicknammed
                        nickNamedName = rData.nicknames[characterName]
                    end
                    new_from, displayed = GetNameLink(characterName, nickNamedName or characterName, CHARACTER_LINK_TYPE)

                elseif db.formatguild[guildName] == 3 then -- Char@UserID
                    local _, characterName = GetGuildMemberCharacterInfo(guildId, GetGuildMemberIndexFromDisplayName(guildId, new_from))
                    characterName = zo_strformat(SI_UNIT_NAME, characterName)
                    if characterName == "" then characterName = new_from end -- Some buggy rosters

                    if rData.nicknames[characterName] then -- Char Nicknamed
                        characterName = rData.nicknames[characterName]
                    else
                        characterName = characterName .. new_from
                    end

                    new_from, displayed = GetNameLink(new_from, characterName, DISPLAY_NAME_LINK_TYPE)

                else
                    new_from, displayed = GetNameLink(new_from, new_from, DISPLAY_NAME_LINK_TYPE)
                end
            end
        else
            -- Wisps with @ We can't guess characterName for those ones
            if rData.nicknames[new_from] then -- @UserID Nicknamed
                new_from, displayed = GetNameLink(new_from, rData.nicknames[new_from], DISPLAY_NAME_LINK_TYPE)

            else
                new_from, displayed = GetNameLink(new_from, new_from, DISPLAY_NAME_LINK_TYPE)
            end

        end

    -- Geo chat, Group, Whisps with characterName
    else
        -- strip gender postfix from toon name
        new_from = zo_strformat(SI_UNIT_NAME, new_from)

        local nicknamedFrom
        if rData.nicknames[new_from] then -- Character Nicknamed
            nicknamedFrom = rData.nicknames[new_from]
        elseif rData.nicknames[fromDisplayName] then
            nicknamedFrom = rData.nicknames[fromDisplayName]
        end

        displayed = nicknamedFrom or new_from

        -- No brackets / UserID for emotes
        if chanCode == CHAT_CHANNEL_EMOTE then
            new_from = ZO_LinkHandler_CreateLinkWithoutBrackets(nicknamedFrom or new_from, nil, CHARACTER_LINK_TYPE, from)
        -- zones / whisps / say / tell. No Handler for NPC
        elseif not (chanCode == CHAT_CHANNEL_MONSTER_SAY or chanCode == CHAT_CHANNEL_MONSTER_YELL or chanCode == CHAT_CHANNEL_MONSTER_WHISPER or chanCode == CHAT_CHANNEL_MONSTER_EMOTE) then

            if chanCode == CHAT_CHANNEL_PARTY then
                if db.groupNames == 1 then
                    new_from, displayed = GetNameLink(fromDisplayName, nicknamedFrom or fromDisplayName, DISPLAY_NAME_LINK_TYPE)
                elseif db.groupNames == 3 then
                    new_from = new_from .. fromDisplayName
                    new_from, displayed = GetNameLink(from, nicknamedFrom or new_from, CHARACTER_LINK_TYPE)
                else
                    new_from, displayed = GetNameLink(from, nicknamedFrom or new_from, CHARACTER_LINK_TYPE)
                end
            else
                if db.geoChannelsFormat == 1 then
                    new_from, displayed = GetNameLink(fromDisplayName, nicknamedFrom or fromDisplayName, DISPLAY_NAME_LINK_TYPE)
                elseif db.geoChannelsFormat == 3 then
                    new_from = new_from .. fromDisplayName
                    new_from, displayed = GetNameLink(from, nicknamedFrom or new_from, CHARACTER_LINK_TYPE)
                else
                    new_from, displayed = GetNameLink(from, nicknamedFrom or new_from, CHARACTER_LINK_TYPE)
                end
            end

        end

    end

    if isCS then -- ZOS icon
        new_from = "|t16:16:EsoUI/Art/ChatWindow/csIcon.dds|t" .. new_from
    end

    return new_from, displayed

end

-- format ESO text to raw text
-- IE : Transforms LinkHandlers into their displayed value
function rChat.FormatRawText(text)

    -- Strip colors from chat
    local newtext = stripColours(text)

    -- Transforms a LinkHandler into its localized displayed value
    -- "|H(.-):(.-)|h(.-)|h" = pattern for Linkhandlers
    -- Item : |H1:item:33753:25:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h = [Battaglir] in french -> Link to item 33753, etc
    -- Achievement |H1:achievement:33753|h|h etc (not searched a lot, was easy)
    -- DisplayName = |H1:display:Ayantir|h[@Ayantir]|h = [@Ayantir] -> link to DisplayName @Ayantir
    -- Book = |H1:book:186|h|h = [Climat de guerre] in french -> Link to book 186 .. GetLoreBookTitleFromLink()
    -- rChat = |H1:RCHAT_LINK:124:11|h[06:18]|h = [06:18] (here 124 is the line number reference and 11 is the chanCode) - URL handling : if chanCode = 97, it will popup a dialog to open internet browser
    -- Character = |H1:character:salhamandhil^Mx|h[salhamandhil]|h = text(here salhamandhil is with brackets voluntary)
    -- Quest_items = |H1:quest_item:4275|h|h

    newtext = string.gsub(newtext, "|H(.-):(.-)|h(.-)|h", function (linkStyle, data, text)
        -- linkStyle = style (0 = no brackets or 1 = brackets)
        -- data = data separated by ":"
        -- text = text displayed, used for Channels, DisplayName, Character, and some fake itemlinks (used by addons)

        -- linktype is : item, achievement, character, channel, book, display, rchatlink
        -- DOES NOT HANDLE ADDONS LINKTYPES

        -- for all types, only param1 is important
        local linkType, param1 = zo_strsplit(':', data)

        -- param1 : itemID
        -- Need to get
        if linkType == ITEM_LINK_TYPE or linkType == COLLECTIBLE_LINK_TYPE  then
            -- Fakelink and GetItemLinkName
            return "[" .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName("|H" .. linkStyle ..":" .. data .. "|h|h")) .. "]"

--      if linkType == GUILD_LINK_TYPE then
--          return "[" .. zo_strformat(GetItemLinkName("|H" .. linkStyle ..":" .. data .. "|h|h")) .. "]"
        -- param1 : achievementID
        elseif linkType == ACHIEVEMENT_LINK_TYPE then
            -- zo_strformat to avoid masculine/feminine problems
            return "[" .. zo_strformat(GetAchievementInfo(param1)) .. "]"
        -- SysMessages Links CharacterNames
        elseif linkType == CHARACTER_LINK_TYPE then
            return text
        elseif linkType == CHANNEL_LINK_TYPE then
            return text
        elseif linkType == BOOK_LINK_TYPE then
            return "[" .. GetLoreBookTitleFromLink(newtext) .. "]"
        -- SysMessages Links DisplayNames
        elseif linkType == DISPLAY_NAME_LINK_TYPE then
            -- No formatting here
            return "[@" .. param1 .. "]"
        -- Used for Sysmessages
        elseif linkType == "quest_item" then
            -- No formatting here
            return "[" .. zo_strformat(SI_TOOLTIP_ITEM_NAME, GetQuestItemNameFromLink(newtext)) .. "]"
        elseif linkType == RCHAT_LINK then
            -- No formatting here .. maybe yes ?..
            return text
        end
    end)

    return newtext

end

-- ------------------------------------------------------
-- Automated Messages

-- Also called by bindings
function rChat.ShowAutoMsg()
    if RAM then
        RAM.ShowAutoMsg()
    else
        CHAT_SYSTEM.Zo_AddMessage("[rChat] Automated Message System is not enabled")
    end
end

-- Register Slash commands
SLASH_COMMANDS["/rchat.msg"] = rChat.ShowAutoMsg

local automatedMessagesList = ZO_SortFilterList:Subclass()

-- Init Automated Messages
function automatedMessagesList:Init(control)

	ZO_SortFilterList.InitializeSortFilterList(self, control)
    local SortKeys = {
        ["name"] = {},
        ["message"] = {tiebreaker = "name"}
    }

    self.masterList = {}
    ZO_ScrollList_AddDataType(self.list, 1, "rChatXMLAutoMsgRowTemplate", 32, function(control, data) self:SetupEntry(control, data) end)
    ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
    self.sortFunction = function(listEntry1, listEntry2) return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, SortKeys, self.currentSortOrder) end

    return self
end

function automatedMessagesList:SetupEntry(control, data)

    control.data = data
    control.name = GetControl(control, "Name")
    control.message = GetControl(control, "Message")

    local messageTrunc = rChat.FormatRawText(data.message)
    if string.len(messageTrunc) > 53 then
        messageTrunc = string.sub(messageTrunc, 1, 53) .. " .."
    end

    control.name:SetText(data.name)
    control.message:SetText(messageTrunc)

    ZO_SortFilterList.SetupRow(self, control, data)

end

function automatedMessagesList:BuildMasterList()
    self.masterList = {}
    local messages = db.automatedMessages
    if messages then
        for k, v in ipairs(messages) do
            local data = v
            table.insert(self.masterList, data)
        end
    end

end

function automatedMessagesList:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    table.sort(scrollData, self.sortFunction)
end

function automatedMessagesList:FilterScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)

    for i = 1, #self.masterList do
        local data = self.masterList[i]
        table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
    end
end

function rChat.SaveAutomatedMessage(name, message, isNew)

    if db then

        local alreadyFav = false

        if isNew then
            for k, v in pairs(db.automatedMessages) do
                if "!" .. name == v.name then
                    alreadyFav = true
                end
            end
        end

        if not alreadyFav then

            rChatXMLAutoMsg:GetNamedChild("Warning"):SetHidden(true)
            rChatXMLAutoMsg:GetNamedChild("Warning"):SetText("")

            if string.len(name) > 12 then
                name = string.sub(name, 1, 12)
            end

            if string.len(message) > 351 then
                message = string.sub(message, 1, 351)
            end

            local entryList = ZO_ScrollList_GetDataList(rData.automatedMessagesList.list)

            if isNew then
                local data = {name = "!" .. name, message = message}
                local entry = ZO_ScrollList_CreateDataEntry(1, data)
                table.insert(entryList, entry)
                table.insert(db.automatedMessages, {name = "!" .. name, message = message}) -- "data" variable is modified by ZO_ScrollList_CreateDataEntry and will crash eso if saved to savedvars
            else

                local data = RAM.FindAutomatedMsg(name)
                local _, index = RAM.FindSavedAutomatedMsg(name)

                data.message = message
                db.automatedMessages[index].message = message
            end

            ZO_ScrollList_Commit(rData.automatedMessagesList.list)

        else
            rChatXMLAutoMsg:GetNamedChild("Warning"):SetHidden(false)
            rChatXMLAutoMsg:GetNamedChild("Warning"):SetText(L(RCHAT_SAVMSGERRALREADYEXISTS))
            rChatXMLAutoMsg:GetNamedChild("Warning"):SetColor(1, 0, 0)
            zo_callLater(function() rChatXMLAutoMsg:GetNamedChild("Warning"):SetHidden(true) end, 5000)
        end

    end

end

-- Init Automated messages, build the scene and handle array of automated strings
function rChat.InitAutomatedMessages()

    -- Create Scene
    RCHAT_AUTOMSG_SCENE = ZO_Scene:New("rChatAutomatedMessagesScene", SCENE_MANAGER)

    -- Mouse standard position and background
    RCHAT_AUTOMSG_SCENE:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
    RCHAT_AUTOMSG_SCENE:AddFragmentGroup(FRAGMENT_GROUP.FRAME_TARGET_STANDARD_RIGHT_PANEL)

    -- Background Right, it will set ZO_RightPanelFootPrint and its stuff.
    RCHAT_AUTOMSG_SCENE:AddFragment(RIGHT_BG_FRAGMENT)

    -- The title fragment
    RCHAT_AUTOMSG_SCENE:AddFragment(TITLE_FRAGMENT)

    -- Set Title
    ZO_CreateStringId("SI_RCHAT_AUTOMSG_TITLE",  rChat.name)
    RCHAT_AUTOMSG_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_RCHAT_AUTOMSG_TITLE)
    RCHAT_AUTOMSG_SCENE:AddFragment(RCHAT_AUTOMSG_TITLE_FRAGMENT)

    -- Add the XML to our scene
    RCHAT_AUTOMSG_SCENE_WINDOW = ZO_FadeSceneFragment:New(rChatXMLAutoMsg)
    RCHAT_AUTOMSG_SCENE:AddFragment(RCHAT_AUTOMSG_SCENE_WINDOW)

    -- Register Scenes and the group name
    SCENE_MANAGER:AddSceneGroup("rChatSceneGroup", ZO_SceneGroup:New("rChatAutomatedMessagesScene"))

    local autoMsgDescriptor = {
        alignment = KEYBIND_STRIP_ALIGN_CENTER,
        {
            name = L(RCHAT_AUTOMSG_ADD_AUTO_MSG),
            keybind = "UI_SHORTCUT_PRIMARY",
            control = self,
            callback = function(descriptor) ZO_Dialogs_ShowDialog("RCHAT_AUTOMSG_SAVE_MSG", nil, {mainTextParams = {functionName}}) end,
            visible = function(descriptor) return true end
        },
        {
            name = L(RCHAT_AUTOMSG_EDIT_AUTO_MSG),
            keybind = "UI_SHORTCUT_SECONDARY",
            control = self,
            callback = function(descriptor)
                    ZO_Dialogs_ShowDialog("RCHAT_AUTOMSG_EDIT_MSG", nil, {mainTextParams = {functionName}})
                end,
            visible = function(descriptor)
                if rData.autoMessagesShowKeybind then
                    return true
                else
                    return false
                end
            end
        },
        {
            name = L(RCHAT_AUTOMSG_REMOVE_AUTO_MSG),
            keybind = "UI_SHORTCUT_NEGATIVE",
            control = self,
            callback = function(descriptor) RAM.RemoveAutomatedMessage(db) end,
            visible = function(descriptor)
                if rData.autoMessagesShowKeybind then
                    return true
                else
                    return false
                end
            end
        },
    }

    local autoMessagesScene = SCENE_MANAGER:GetScene("rChatAutomatedMessagesScene")
    autoMessagesScene:RegisterCallback("StateChange", function(oldState, newState)
        if newState == SCENE_SHOWING then
            KEYBIND_STRIP:AddKeybindButtonGroup(autoMsgDescriptor)
        elseif newState == SCENE_HIDDEN then
            if KEYBIND_STRIP:HasKeybindButtonGroup(autoMsgDescriptor) then
                KEYBIND_STRIP:RemoveKeybindButtonGroup(autoMsgDescriptor)
            end
        end
    end)

    if not db.automatedMessages then
        db.automatedMessages = {}
    end

    rData.automatedMessagesList = automatedMessagesList:Init(rChatXMLAutoMsg)
    rData.automatedMessagesList:RefreshData()
    RAM.CleanAutomatedMessageList(db)


    rData.automatedMessagesList.keybindStripDescriptor = autoMsgDescriptor

end

-- Called by XML
function rChat_BuildAutomatedMessagesDialog(control, saveFunc)
    RAM.BuildAutomatedMessagesDialog(control, saveFunc)
end


-- **************************************************************************
-- Chat Tab Functions
-- **************************************************************************
local function getTabNames()
    local totalTabs = CHAT_SYSTEM.tabPool.m_Active
    if totalTabs ~= nil and #totalTabs >= 1 then
        rChat.tabNames = {}
        for idx, tmpTab in pairs(totalTabs) do
            local tabLabel = tmpTab:GetNamedChild("Text")
            local tmpTabName = tabLabel:GetText()
            if tmpTabName ~= nil and tmpTabName ~= "" then
                rChat.tabNames[idx] = tmpTabName
            end
        end
    end
end

local function getTabIdx (tabName)
    local tabIdx = 0
    local totalTabs = CHAT_SYSTEM.tabPool.m_Active
    for i = 1, #totalTabs do
        if rChat.tabNames[i] == tabName then
            tabIdx = i
            break
        end
    end
    return tabIdx
end

-- Change ChatWindow Darkness by modifying its <Center> & <Edge>.
-- Originally defined in virtual object ZO_ChatContainerTemplate in sharedchatsystem.xml
local function ChangeChatWindowDarkness(changeSetting)

    if dbWindowDarkness == 0 then
        ZO_ChatWindowBg:SetCenterTexture("EsoUI/Art/ChatWindow/chat_BG_center.dds")
        ZO_ChatWindowBg:SetEdgeTexture("EsoUI/Art/ChatWindow/chat_BG_edge.dds", 256, 256, 32)
    else
        ZO_ChatWindowBg:SetCenterColor(0, 0, 0, 1)
        ZO_ChatWindowBg:SetEdgeColor(0, 0, 0, 1)
        if db.windowDarkness == 11 and changeSetting then
            ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_100.dds")
            ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_100.dds", 256, 256, 32)
        elseif db.windowDarkness == 10 then
            ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_90.dds")
            ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_90.dds", 256, 256, 32)
        elseif db.windowDarkness == 9 then
            ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_80.dds")
            ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_80.dds", 256, 256, 32)
        elseif db.windowDarkness == 8 then
            ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_70.dds")
            ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_70.dds", 256, 256, 32)
        elseif db.windowDarkness == 7 then
            ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_60.dds")
            ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_60.dds", 256, 256, 32)
        elseif db.windowDarkness == 6 then
            ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_50.dds")
            ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_50.dds", 256, 256, 32)
        elseif db.windowDarkness == 5 then
            ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_40.dds")
            ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_40.dds", 256, 256, 32)
        elseif db.windowDarkness == 4 then
            ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_30.dds")
            ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_30.dds", 256, 256, 32)
        elseif db.windowDarkness == 3 then
            ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_20.dds")
            ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_20.dds", 256, 256, 32)
        elseif db.windowDarkness == 2 then
            ZO_ChatWindowBg:SetCenterTexture("rChat/dds/chat_bg_center_10.dds")
            ZO_ChatWindowBg:SetEdgeTexture("rChat/dds/chat_bg_edge_10.dds", 256, 256, 32)
        elseif db.windowDarkness == 1 then
            ZO_ChatWindowBg:SetCenterColor(0, 0, 0, 0)
            ZO_ChatWindowBg:SetEdgeColor(0, 0, 0, 0)
        end
    end
end

-- ----------------------------------------------------------------
-- Whisper functions

-- Add IM label on XML Initialization, set anchor and set it hidden
function rChat_AddIMLabel(control)

    control:SetParent(CHAT_SYSTEM.control)
    control:ClearAnchors()
    control:SetAnchor(RIGHT, ZO_ChatWindowOptions, LEFT, -5, 32)
    CHAT_SYSTEM.IMLabel = control

end

-- Add IM label on XML Initialization, set anchor and set it hidden. Used for Chat Minibar
function rChat_AddIMLabelMin(control)

    control:SetParent(CHAT_SYSTEM.control)
    control:ClearAnchors()
    control:SetAnchor(BOTTOM, CHAT_SYSTEM.minBar.maxButton, TOP, 2, 0)
    CHAT_SYSTEM.IMLabelMin = control

end

-- Add IM close button on XML Initialization, set anchor and set it hidden
function rChat_AddIMButton(control)

    control:SetParent(CHAT_SYSTEM.control)
    control:ClearAnchors()
    control:SetAnchor(RIGHT, ZO_ChatWindowOptions, LEFT, 2, 35)
    CHAT_SYSTEM.IMbutton = control

end

-- Hide it
local function HideIMTooltip()
    ClearTooltip(InformationTooltip)
end

-- Show IM notification tooltip
local function ShowIMTooltip(self, lineNumber)

    local chatline = CACHE.getCacheEntry(lineNumber)
    if not chatline then return end

    local sender = chatline.rawFrom
    local text = chatline.rawMessage

    if (not IsDecoratedDisplayName(sender)) then
        sender = zo_strformat(SI_UNIT_NAME, sender)
    end

    InitializeTooltip(InformationTooltip, self, BOTTOMLEFT, 0, 0, TOPRIGHT)
    InformationTooltip:AddLine(sender, "ZoFontGame", 1, 1, 1, TOPLEFT, MODIFY_TEXT_TYPE_NONE, TEXT_ALIGN_LEFT, true)

    local r, g, b = ZO_NORMAL_TEXT:UnpackRGB()
    InformationTooltip:AddLine(text, "ZoFontGame", r, g, b, TOPLEFT, MODIFY_TEXT_TYPE_NONE, TEXT_ALIGN_LEFT, true)


end

-- When an incoming Whisper is received
local function OnIMReceived(from, lineNumber)

    if not db.notifyIM then return end

    -- Display visual notification
    -- If chat minimized, show the minified button
    if (CHAT_SYSTEM:IsMinimized()) then
        CHAT_SYSTEM.IMLabelMin:SetHandler("OnMouseEnter", function(self) ShowIMTooltip(self, lineNumber) end)
        CHAT_SYSTEM.IMLabelMin:SetHandler("OnMouseExit", HideIMTooltip)
        CHAT_SYSTEM.IMLabelMin:SetHidden(false)
    else
        -- Chat maximized
        local _, scrollMax = CHAT_SYSTEM.primaryContainer.scrollbar:GetMinMax()

        -- If whispers not show in the tab or we don't scroll at bottom
        if ((not IsChatContainerTabCategoryEnabled(1, rData.activeTab, CHAT_CATEGORY_WHISPER_INCOMING)) or (IsChatContainerTabCategoryEnabled(1, rData.activeTab, CHAT_CATEGORY_WHISPER_INCOMING) and CHAT_SYSTEM.primaryContainer.scrollbar:GetValue() < scrollMax)) then

            -- Undecorate (^F / ^M)
            if (not IsDecoratedDisplayName(from)) then
                from = zo_strformat(SI_UNIT_NAME, from)
            end

            -- Split if name too long
            local displayedFrom = from
            if string.len(displayedFrom) > 8 then
                displayedFrom = string.sub(from, 1, 7) .. ".."
            end

            -- Show
            CHAT_SYSTEM.IMLabel:SetText(displayedFrom)
            CHAT_SYSTEM.IMLabel:SetHidden(false)
            CHAT_SYSTEM.IMbutton:SetHidden(false)

            -- Add handler
            CHAT_SYSTEM.IMLabel:SetHandler("OnMouseEnter", function(self) ShowIMTooltip(self, lineNumber) end)
            CHAT_SYSTEM.IMLabel:SetHandler("OnMouseExit", function(self) HideIMTooltip() end)
        end
    end

end

-- Hide IM notification when click on it. Can be Called by XML
function rChat_RemoveIMNotification()
    CHAT_SYSTEM.IMLabel:SetHidden(true)
    CHAT_SYSTEM.IMLabelMin:SetHidden(true)
    CHAT_SYSTEM.IMbutton:SetHidden(true)
end

-- Will try to display the notified IM. Called by XML
function rChat_TryToJumpToIm(isMinimized)

    -- Show chat first
    if isMinimized then
        CHAT_SYSTEM:Maximize()
        CHAT_SYSTEM.IMLabelMin:SetHidden(true)
    end

    -- Tab get IM, scroll
    if IsChatContainerTabCategoryEnabled(1, rData.activeTab, CHAT_CATEGORY_WHISPER_INCOMING) then
        ZO_ChatSystem_ScrollToBottom(CHAT_SYSTEM.control)
        rChat_RemoveIMNotification()
    else

        -- Tab don't have IM's, switch to next
        local numTabs = #CHAT_SYSTEM.primaryContainer.windows
        local actualTab = rData.activeTab + 1
        local oldActiveTab = rData.activeTab
        local PRESSED = 1
        local UNPRESSED = 2
        local hasSwitched = false
        local maxt = 1

        while actualTab <= numTabs and (not hasSwitched) do
            if IsChatContainerTabCategoryEnabled(1, actualTab, CHAT_CATEGORY_WHISPER_INCOMING) then

                CHAT_SYSTEM.primaryContainer:HandleTabClick(CHAT_SYSTEM.primaryContainer.windows[actualTab].tab)

                local tabText = GetControl("ZO_ChatWindowTabTemplate" .. actualTab .. "Text")
                tabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
                tabText:GetParent().state = PRESSED
                local oldTabText = GetControl("ZO_ChatWindowTabTemplate" .. oldActiveTab .. "Text")
                oldTabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_CONTRAST))
                oldTabText:GetParent().state = UNPRESSED
                ZO_ChatSystem_ScrollToBottom(CHAT_SYSTEM.control)

                hasSwitched = true
            else
                actualTab = actualTab + 1
            end
        end

        actualTab = 1

        -- If we were on tab #3 and IM are show on tab #2, need to restart from 1
        while actualTab < oldActiveTab and (not hasSwitched) do
            if IsChatContainerTabCategoryEnabled(1, actualTab, CHAT_CATEGORY_WHISPER_INCOMING) then

                CHAT_SYSTEM.primaryContainer:HandleTabClick(CHAT_SYSTEM.primaryContainer.windows[actualTab].tab)

                local tabText = GetControl("ZO_ChatWindowTabTemplate" .. actualTab .. "Text")
                tabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
                tabText:GetParent().state = PRESSED
                local oldTabText = GetControl("ZO_ChatWindowTabTemplate" .. oldActiveTab .. "Text")
                oldTabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_CONTRAST))
                oldTabText:GetParent().state = UNPRESSED
                ZO_ChatSystem_ScrollToBottom(CHAT_SYSTEM.control)

                hasSwitched = true
            else
                actualTab = actualTab + 1
            end
        end

    end

end
-- ----------------------------------------------------------------

-- ------------------------------------------------------
-- Copy functions

-- Set copied text into chatbox text entry, if possible
local function CopyToTextEntry(message)

    -- Max of inputbox is 351 chars
    if string.len(message) < 351 then
        if CHAT_SYSTEM.textEntry:GetText() == "" then
            CHAT_SYSTEM.textEntry:Open(message)
            ZO_ChatWindowTextEntryEditBox:SelectAll()
        end
    end

end

-- Copy message (only message)
local function CopyMessage(numLine)
    -- Args are passed as string through LinkHandlerSystem
    local entry = CACHE.getCacheEntry(numLine)
    if entry then
        CopyToTextEntry(entry.rawMessage)
    end
end

--Copy line (including timestamp, from, channel, message, etc)
local function CopyLine(numLine)
    -- Args are passed as string through LinkHandlerSystem
    local entry = CACHE.getCacheEntry(numLine)
    if entry then
        CopyToTextEntry(entry.rawLine)
    end
end

-- Popup a dialog message with text to copy
local function ShowCopyDialog(message)

    local maxChars      = 20000

    -- editbox is 20000 chars max
    if string.len(message) < maxChars then
        rChatCopyDialogTLCTitle:SetText(L(RCHAT_COPYXMLTITLE))
        rChatCopyDialogTLCLabel:SetText(L(RCHAT_COPYXMLLABEL))
        rChatCopyDialogTLCNoteEdit:SetText(message)
        rChatCopyDialogTLCNoteNext:SetHidden(true)
        rChatCopyDialogTLC:SetHidden(false)
        rChatCopyDialogTLCNoteEdit:SetEditEnabled(false)
        rChatCopyDialogTLCNoteEdit:SelectAll()
    else

        rChatCopyDialogTLCTitle:SetText(L(RCHAT_COPYXMLTITLE))
        rChatCopyDialogTLCLabel:SetText(L(RCHAT_COPYXMLTOOLONG))

        rData.messageTableId = 1
        rData.messageTable = rChat.strSplitMB(message, maxChars)
        rChatCopyDialogTLCNoteNext:SetText(L(RCHAT_COPYXMLNEXT) .. " ( " .. rData.messageTableId .. " / " .. #rData.messageTable .. " )")
        rChatCopyDialogTLCNoteEdit:SetText(rData.messageTable[rData.messageTableId])
        rChatCopyDialogTLCNoteEdit:SetEditEnabled(false)
        rChatCopyDialogTLCNoteEdit:SelectAll()

        rChatCopyDialogTLC:SetHidden(false)
        rChatCopyDialogTLCNoteNext:SetHidden(false)

        rChatCopyDialogTLCNoteEdit:TakeFocus()

    end

end

-- Copy discussion
-- It will copy all text mark with the same chanCode
-- Todo : Whisps by person
local function CopyDiscussion(chanNumber, numLine)
    local entry = CACHE.getCacheEntry(numLine)
    if not entry then return end

    -- Args are passed as string through LinkHandlerSystem
    local numChanCode = tonumber(chanNumber)
    -- Whispers sent and received together
    if numChanCode == CHAT_CHANNEL_WHISPER_SENT then
        numChanCode = CHAT_CHANNEL_WHISPER
    elseif numChanCode == RCHAT_URL_CHAN then
        numChanCode = entry.channel
    end

    local stringToCopy = ""
    for k, data in CACHE.iterCache() do
        if numChanCode == CHAT_CHANNEL_WHISPER or numChanCode == CHAT_CHANNEL_WHISPER_SENT then
            if data.channel == CHAT_CHANNEL_WHISPER or data.channel == CHAT_CHANNEL_WHISPER_SENT then
                if stringToCopy == "" then
                    stringToCopy = data.rawLine
                else
                    stringToCopy = stringToCopy .. "\r\n" .. data.rawLine
                end
            end
        elseif data.channel == numChanCode then
            if stringToCopy == "" then
                stringToCopy = data.rawLine
            else
                stringToCopy = stringToCopy .. "\r\n" .. data.rawLine
            end
        end
    end
    ShowCopyDialog(stringToCopy)

end

-- Copy Whole chat (not tab)
local function CopyWholeChat()

    local stringToCopy = ""
    for k, data in CACHE.iterCache() do
        if stringToCopy == "" then
            stringToCopy = data.rawLine
        else
            stringToCopy = stringToCopy .. "\r\n" .. data.rawLine
        end
    end

    ShowCopyDialog(stringToCopy)

end

local function CopyToTextEntryText()
    LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_CLICKED_EVENT, OnLinkClicked)
    LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_MOUSE_UP_EVENT, OnLinkClicked)
end

-- Called by XML
function rChat_ShowCopyDialogNext()

    rData.messageTableId = rData.messageTableId + 1

    -- Security
    if rData.messageTable[rData.messageTableId] then

        -- Build button
        rChatCopyDialogTLCNoteNext:SetText(L(RCHAT_COPYXMLNEXT) .. " ( " .. rData.messageTableId .. " / " .. #rData.messageTable .. " )")
        rChatCopyDialogTLCNoteEdit:SetText(rData.messageTable[rData.messageTableId])
        rChatCopyDialogTLCNoteEdit:SetEditEnabled(false)
        rChatCopyDialogTLCNoteEdit:SelectAll()

        -- Don't show next button if its the last
        if not rData.messageTable[rData.messageTableId + 1] then
            rChatCopyDialogTLCNoteNext:SetHidden(true)
        end

        rChatCopyDialogTLCNoteEdit:TakeFocus()

    end

end

-- ------------------------------------------------------


-- ------------------------------------------------------
-- RCHAT_LINK Context Menu

-- Show contextualMenu when clicking on a rChatLink
local function ShowContextMenuOnHandlers(numLine, chanNumber)

    ClearMenu()

    if not ZO_Dialogs_IsShowingDialog() then
        AddMenuItem(L(RCHAT_COPYMESSAGECT), function() CopyMessage(numLine) end)
        AddMenuItem(L(RCHAT_COPYLINECT), function() CopyLine(numLine) end)
        AddMenuItem(L(RCHAT_COPYDISCUSSIONCT), function() CopyDiscussion(chanNumber, numLine) end)
        AddMenuItem(L(RCHAT_ALLCT), CopyWholeChat)
    end

    ShowMenu()

end

-- Triggers when right clicking on a LinkHandler
local function OnLinkClicked(rawLink, mouseButton, linkText, color, linkType, lineNumber, chanCode)

    if linkType ~= RCHAT_LINK then return end
    if db.enablecopy then

        -- Only executed on LinkType = RCHAT_LINK
        local chanNumber = tonumber(chanCode)
        local numLine = tonumber(lineNumber)
        local entry = CACHE.getCacheEntry(numLine)

        if not entry then return end
        -- RCHAT_LINK also handle a linkable channel feature for linkable channels

        -- Context Menu
        if chanCode and mouseButton == MOUSE_BUTTON_INDEX_LEFT then

            if chanNumber == CHAT_CHANNEL_WHISPER then
                local target = zo_strformat(SI_UNIT_NAME, entry.rawFrom)
                IgnoreMouseDownEditFocusLoss()
                CHAT_SYSTEM:StartTextEntry(nil, chanNumber, target)

            elseif chanNumber == RCHAT_URL_CHAN then
                RequestOpenUnsafeURL(linkText)

            else
                local channelInfo = ZO_ChatSystem_GetChannelInfo()[chanNumber]
                if channelInfo and channelInfo.playerLinkable then
                    IgnoreMouseDownEditFocusLoss()
                    CHAT_SYSTEM:StartTextEntry(nil, chanNumber)
                end
            end


        elseif mouseButton == MOUSE_BUTTON_INDEX_RIGHT then
            -- Right click, copy System
            ShowContextMenuOnHandlers(numLine, chanNumber)
        end

        -- Don't execute LinkHandler code
        return true
    end
end
-- ------------------------------------------------------
-- Tab functions

-- Needed to bind Shift+Tab in SetSwitchToNextBinding
function KEYBINDING_MANAGER:IsChordingAlwaysEnabled()
    return true
end

local function SetSwitchToNextBinding()

    ZO_CreateStringId("SI_BINDING_NAME_RCHAT_SWITCH_TAB", L(RCHAT_SWITCHTONEXTTABBINDING))

    -- get SwitchTab Keybind params
    local layerIndex, categoryIndex, actionIndex = GetActionIndicesFromName("RCHAT_SWITCH_TAB")

    --If exists
    if layerIndex and categoryIndex and actionIndex then

        local key = GetActionBindingInfo(layerIndex, categoryIndex, actionIndex, 1)

        if key == KEY_INVALID then
            -- Unbind it
            if IsProtectedFunction("UnbindAllKeysFromAction") then
                CallSecureProtected("UnbindAllKeysFromAction", layerIndex, categoryIndex, actionIndex)
            else
                UnbindAllKeysFromAction(layerIndex, categoryIndex, actionIndex)
            end

            -- Set it to its default value
            if IsProtectedFunction("BindKeyToAction") then
                CallSecureProtected("BindKeyToAction", layerIndex, categoryIndex, actionIndex, 1, KEY_TAB, 0, 0, KEY_SHIFT, 0)
            else
                BindKeyToAction(layerIndex, categoryIndex, actionIndex, 1, KEY_TAB , 0, 0, KEY_SHIFT, 0)
            end
        end

    end

end

-- Can be called by Bindings
function rChat.SwitchToNextTab()

    local hasSwitched

    local PRESSED = 1
    local UNPRESSED = 2
    local numTabs = #CHAT_SYSTEM.primaryContainer.windows

    if numTabs > 1 then
        for numTab, container in ipairs (CHAT_SYSTEM.primaryContainer.windows) do

            if (not hasSwitched) then
                if rData.activeTab + 1 == numTab then
                    CHAT_SYSTEM.primaryContainer:HandleTabClick(container.tab)

                    local tabText = GetControl("ZO_ChatWindowTabTemplate" .. numTab .. "Text")
                    tabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
                    tabText:GetParent().state = PRESSED
                    local oldTabText = GetControl("ZO_ChatWindowTabTemplate" .. numTab - 1 .. "Text")
                    oldTabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_CONTRAST))
                    oldTabText:GetParent().state = UNPRESSED

                    hasSwitched = true
                end
            end

        end

        if (not hasSwitched) then
            CHAT_SYSTEM.primaryContainer:HandleTabClick(CHAT_SYSTEM.primaryContainer.windows[1].tab)
            local tabText = GetControl("ZO_ChatWindowTabTemplate1Text")
            tabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
            tabText:GetParent().state = PRESSED
            local oldTabText = GetControl("ZO_ChatWindowTabTemplate" .. #CHAT_SYSTEM.primaryContainer.windows .. "Text")
            oldTabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_CONTRAST))
            oldTabText:GetParent().state = UNPRESSED
        end
    end

end

local function SetDefaultTab(tabToSet)

    if not tabToSet then return end

    -- Search in all tabs the good name
    for numTab in ipairs(CHAT_SYSTEM.primaryContainer.windows) do
        -- Not this one, try the next one, if tab is not found (newly added, removed),
        -- rChat_SwitchToNextTab() will go back to tab 1
        if tonumber(tabToSet) ~= numTab then
            rChat.SwitchToNextTab()
        else
            -- Found it, stop
            return
        end
    end
end

function rChat.ChangeTab(tabToSet)
    if type(tabToSet)~="number" then return end

    local container=CHAT_SYSTEM.primaryContainer
    if not container then return end

    if tabToSet<1 or tabToSet>#container.windows then return end
    if container.windows[tabToSet].tab==nil then return end

    container.tabGroup:SetClickedButton(container.windows[tabToSet].tab)
    if CHAT_SYSTEM:IsMinimized() then CHAT_SYSTEM:Maximize() end
end

local function CreateNewChatTab_PostHook()

    for tabIndex, tabObject in ipairs(CHAT_SYSTEM.primaryContainer.windows) do
        if db.augmentHistoryBuffer then
            tabObject.buffer:SetMaxHistoryLines(1000) -- 1000 = max of control
        end
        if db.alwaysShowChat then
            tabObject.buffer:SetLineFade(3600, 2)
        end
    end

end
-- ------------------------------------------------------


-- Prune lines from saved cache
-- Lines must be no older than our threshold,
-- and we keep no more than 5000
--
-- Still need the channel filtering part of this
local function StripLinesFromLineStrings(typeOfExit)
--[[
    local function removeLine(index)
        table.remove(db.LineStrings, index)
        db.lineNumber = db.lineNumber - 1
        index = index-1
        return index
    end

    -- 1st loop is size based. If dump is too big, just delete old ones
    if #db.LineStrings > 5000 then
        local linesToDelete = #db.LineStrings - 5000
        for l=1, linesToDelete do
            if db.LineStrings[1] then
                removeLine(1)
            end
        end
    end

    local k = 1
    -- 2nd loop is time based. If message is older than our limit, it will be stripped.
    local curtime= GetTimeStamp()
    while k <= #db.LineStrings do

        if db.LineStrings[k] then
            local channel = db.LineStrings[k].channel
            if channel == CHAT_CHANNEL_SYSTEM and (not db.restoreSystem) then
                k = removeLine(k)
            elseif channel ~= CHAT_CHANNEL_SYSTEM and db.restoreSystemOnly then
                k = removeLine(k)
            elseif (channel == CHAT_CHANNEL_WHISPER or channel == CHAT_CHANNEL_WHISPER_SENT) and (not db.restoreWhisps) then
                k = removeLine(k)
            -- bad bad bad
            elseif typeOfExit ~= 1 and type(db.LineStrings[k].timestamp) == "number" then
                if (curtime - db.LineStrings[k].timestamp) > (db.timeBeforeRestore * HRS_TO_SEC) then
                    k = removeLine(k)
                elseif db.LineStrings[k].timestamp > curtime then -- System clock of users computer badly set and msg received meanwhile.
                    k = removeLine(k)
                end
            end
        end

        k = k + 1

    end
--]]

end

-- save a flag in saved variables so that when we are reloaded
-- by whatever means, we can decide what to restore to chat.
local function SaveChatHistory(typeOf)

    local function ClearLasts()
        db.lastWasReloadUI = false
        db.lastWasLogOut = false
        db.lastWasQuit = false
        db.lastWasAFK = false
    end

    local function ShouldReload(exitType)
        if (db.restoreOnReloadUI == true and exitType == 1)             -- reloadui
                or (db.restoreOnLogOut == true and exitType == 2)       -- logged out
                or (db.restoreOnAFK == true)                            -- timed out of game
                or (db.restoreOnQuit == true and exitType == 3) then    -- quit game
            return true
        else
            return false
        end
    end

    db.history = {}

    if ShouldReload(typeOf) then

        if typeOf == 1 then     -- reloadui
            ClearLasts()
            db.lastWasReloadUI = true

            --Save actual channel
            db.history.currentChannel = CHAT_SYSTEM.currentChannel
            db.history.currentTarget = CHAT_SYSTEM.currentTarget

        elseif typeOf == 2 then     -- logout
            ClearLasts()
            db.lastWasLogOut = true

        elseif typeOf == 3 then     -- quit
            ClearLasts()
            db.lastWasQuit = true
        end

        db.history.currentTab = rData.activeTab

        -- strip some lines from the array to avoid big dumps
        StripLinesFromLineStrings(typeOf)

        --Save TextEntry history
        db.history.textEntry = {}
        if CHAT_SYSTEM.textEntry.commandHistory.entries then
            db.history.textEntry.entries = CHAT_SYSTEM.textEntry.commandHistory.entries
            db.history.textEntry.numEntries = CHAT_SYSTEM.textEntry.commandHistory.index
        else
            db.history.textEntry.entries = {}
            db.history.textEntry.numEntries = 0
        end
    else
        CACHE.clearCache()
    end

end

local function ShowFadedLines()

	SecurePostHook(CHAT_SYSTEM, "CreateNewChatTab", function()
		CreateNewChatTab_PostHook()
	end)
end

local function OnReticleTargetChanged()
    if IsUnitPlayer("reticleover") then
        targetToWhisp = GetUnitName("reticleover")
    end
end

local function BuildNicknames(lamCall)

    local function Explode(div, str)
        if (div=='') then return false end
        local pos,arr = 0,{}
        for st,sp in function() return string.find(str,div,pos,true) end do
            table.insert(arr,string.sub(str,pos,st-1))
            pos = sp + 1
        end
        table.insert(arr,string.sub(str,pos))
        return arr
    end

    rData.nicknames = {}

    if db.nicknames ~= "" then
        local lines = Explode("\n", db.nicknames)

        for lineIndex=#lines, 1, -1 do
            local oldName, newName = string.match(lines[lineIndex], "(@?[%w_-]+) ?= ?([%w- ]+)")
            if not (oldName and newName) then
                table.remove(lines, lineIndex)
            else
                rData.nicknames[oldName] = newName
            end
        end

        db.nicknames = table.concat(lines, "\n")

        if lamCall then
            CALLBACK_MANAGER:FireCallbacks("LAM-RefreshPanel", rData.LAMPanel)
        end

    end

end

-- Change font of chat
local function ChangeChatFont(change)

    local fontSize = GetChatFontSize()
    if db.fonts == "ESO Standard Font" or db.fonts == "Univers 57" then
        return
    else
        local fontPath = LMP:Fetch("font", db.fonts)
        -- Entry Box
        ZoFontEditChat:SetFont(fontPath .. "|".. fontSize .. "|shadow")
        -- Chat window
        ZoFontChat:SetFont(fontPath .. "|" .. fontSize .. "|soft-shadow-thin")
    end
end

-- Change guild channel names in entry box
local function UpdateGuildChannelNames()

    -- Each guild
    local ChanInfoArray = ZO_ChatSystem_GetChannelInfo()
    for i = 1, GetNumGuilds() do
        local gname = rChat.SafeGetGuildName(i)
        local guild_channel, officer_channel = GetGuildChannel(i)
        if db.showTagInEntry then

            -- Get saved string
            local tag = db.guildTags[gname]
            if not tag or tag == ""then
                tag = gname
            end

            -- Get saved string
            local officertag = db.officertag[gname]
            if not officertag or officertag == "" then
                officertag = tag
            end

            -- /g1 is 12 /g5 is 16, /o1=17, etc
            ChanInfoArray[guild_channel].name = tag
            ChanInfoArray[officer_channel].name = officertag
            --Activating
            ChanInfoArray[guild_channel].dynamicName = false
            ChanInfoArray[officer_channel].dynamicName = false

        else
            -- /g1 is 12 /g5 is 16, /o1=17, etc
            ChanInfoArray[guild_channel].name = gname
            ChanInfoArray[officer_channel].name = gname
            --Deactivating
            ChanInfoArray[guild_channel].dynamicName = true
            ChanInfoArray[officer_channel].dynamicName = true
        end
    end

    return

end

-- Sub function of addLinkHandlerToString
-- Get a string without |cXXXXXX and without |t as parameter
local function AddLinkHandlerToStringWithoutDDS(textToCheck, numLine, chanCode)

    if not textToCheck or textToCheck == "" then return "" end
    local stillToParse = true
    local noColorlen = textToCheck:len()

    local startNoColor = 1
    local textLinked = ""
    local preventLoopsCol = 0
    local handledText = ""
    local logger = LibDebugLogger("rChat")
    logger:SetEnabled(true)

    while stillToParse do
        -- Prevent infinite loops while its still in beta
        if preventLoopsCol > 10 then
            stillToParse = false
            CHAT_SYSTEM:Zo_AddMessage("rChat triggered an infinite LinkHandling loop in its copy system with last message : " .. textToCheck .. " -- rChat")
        else
            preventLoopsCol = preventLoopsCol + 1
        end

        noColorlen = textToCheck:len()

        --local startpos, endpos = string.find(textToCheck, "|H(.-):(.-)|h(.-)|h", 1)
        local startpos, endpos = string.find(textToCheck, "|[hH](.-)|[hH](.-)|[hH]", 1)
        -- LinkHandler not found
        if not startpos then
            -- If nil, then we won't have new link after startposition = startNoColor , so add ours util the end

            -- Some addons use table.insert() and chat convert to a CRLF
            -- First, drop the final CRLF if we are at the end of the text
            if string.sub(textToCheck, -2) == "\r\n" then
                textToCheck = string.sub(textToCheck, 1, -2)
            end
            -- MultiCRLF is handled in .addLinkHandler()

            textLinked = rChat.SplitTextForLinkHandler(textToCheck, numLine, chanCode)
            handledText = handledText .. textLinked

            -- No need to parse after
            stillToParse = false

        else

            -- Link is at the beginning of the string
            if startpos == 1 then
                -- New text is (only handler because its at the pos 1)
                handledText = handledText .. textToCheck:sub(startpos, endpos)

                -- Do we need to continue ?
                if endpos == noColorlen then
                    -- We're at the end
                    stillToParse = false
                else
                    -- Still to parse
                    startNoColor = endpos
                    -- textToCheck is next to our string
                    textToCheck = textToCheck:sub(startNoColor + 1)
                end

            else

                -- We Handle string from startNoColor of the message up to the Handle link
                local textToHandle = textToCheck:sub(1, startpos - 1)

                -- Add ours
                -- Maybe we need a split due to 106 chars restriction
                textLinked = rChat.SplitTextForLinkHandler(textToHandle, numLine, chanCode)

                -- New text is handledText + (textLinked .. LinkHandler)
                handledText = handledText .. textLinked
                handledText = handledText .. textToCheck:sub(startpos, endpos)

                -- Do we need to continue ?
                if endpos == noColorlen then
                    -- We're at the end
                    stillToParse = false
                else
                    -- Still to parse
                    startNoColor = endpos
                    -- textToCheck is next to our string
                    textToCheck = textToCheck:sub(startNoColor + 1)
                end

            end
        end
    end
    return handledText

end

-- Sub function of addLinkHandlerToLine, Handling DDS textures in chat
-- Get a string without |cXXXXXX as parameter
local function AddLinkHandlerToString(textToCheck, numLine, chanCode)

    local stillToParseDDS = true
    local noDDSlen = textToCheck:len()

    -- this var seems to get some rework
    local startNoDDS = 1
    local textLinked = ""
    local preventLoopsDDS = 0
    local textTReformated = ""

    -- Seems the "|" are truncated from the link when send to chatsystem (they're needed for build link, but the output does not include them)

    while stillToParseDDS do

        -- Prevent infinite loops while its still in beta
        if preventLoopsDDS > 20 then
            stillToParseDDS = false
            CHAT_SYSTEM:Zo_AddMessage("rChat triggered an infinite DDS loop in its copy system with last message : " .. textToCheck .. " -- rChat")
        else
            preventLoopsDDS = preventLoopsDDS + 1
        end

        noDDSlen = textToCheck:len()

        local startpos, endpos = string.find(textToCheck, "|t%-?%d+%%?:%-?%d+%%?:.-|t", 1)
        -- DDS not found
        if startpos == nil then
            -- If nil, then we won't have new link after startposition = startNoDDS , so add ours until the end

            textLinked = AddLinkHandlerToStringWithoutDDS(textToCheck, numLine, chanCode)
            textTReformated = textTReformated .. textLinked

            -- No need to parse after
            stillToParseDDS = false

        else
            -- DDS is at the beginning of the string
            if startpos == 1 then
                -- New text is (only DDS because its at the pos 1)
                textTReformated = textTReformated .. textToCheck:sub(startpos, endpos)

                -- Do we need to continue ?
                if endpos == noDDSlen then
                    -- We're at the end
                    stillToParseDDS = false
                else
                    -- Still to parse
                    startNoDDS = endpos
                    -- textToCheck is next to our string
                    textToCheck = textToCheck:sub(startNoDDS + 1)
                end

            else

                -- We Handle string from startNoDDS of the message up to the Handle link
                local textToHandle = textToCheck:sub(1, startpos - 1)

                -- Add ours
                textLinked = AddLinkHandlerToStringWithoutDDS(textToHandle, numLine, chanCode)

                -- New text is formattedText + (textLinked .. DDS)
                textTReformated = textTReformated .. textLinked

                textTReformated = textTReformated .. textToCheck:sub(startpos, endpos)

                -- Do we need to continue ?
                if endpos == noDDSlen then
                    -- We're at the end
                    stillToParseDDS = false
                else
                    -- Still to parse
                    startNoDDS = endpos
                    -- textToCheck is next to our string
                    textToCheck = textToCheck:sub(startNoDDS + 1)
                end

            end
        end
    end
    return textTReformated

end

-- Reformat Colored Sysmessages to the correct format
-- Bad format = |[cC]XXXXXXblablabla[,|[cC]XXXXXXblablabla,(...)] with optional |r
-- Good format : "|c%x%x%x%x%x%x(.-)|r"
--
-- TODO : Handle LinkHandler + Malformatted strings , such as : "|c87B7CC|c87B7CCUpdated: |H0:achievement:68:5252:0|h|h (Artisanat)."
local function ReformatSysMessages(text)
     if not text then return "",{} end

    -- get positions of all of the desired delimiters
    local t1 = SF.getAllColorDelim(text)

    if #t1 == 0 then
        -- no delimiters in string
        return text,{text}
    end

    -- balance and correct color markers
    SF.regularizeColors(t1, text)
    local splitcolors = SF.colorsplit(t1, text)
    rawSys = table.concat(splitcolors)

    -- |u search (strip out hard padding)
    rawSys = string.gsub(rawSys,"|u%-?%d+%%?:%-?%d+%%?:(.-):|u","%1")

    return rawSys, splitcolors

end

-- Add rChatLinks Handlers on the whole text except LinkHandlers already here
local function AddLinkHandlerToLine(text, chanCode, numLine)

    local rawText, colorsplit = ReformatSysMessages(text)
    for k,v in ipairs(colorsplit) do
        if v:sub(1,1) ~= "|" then
            colorsplit[k] = AddLinkHandlerToString(v, numLine, chanCode)
        end
    end
    local newtext = table.concat(colorsplit)
    return newtext

end

-- Split lines using CRLF for function addLinkHandlerToLine
local function AddLinkHandler(text, chanCode, numLine)
    if not text then return end

    -- Some Addons output multiple lines into a message
    -- Split the entire string with CRLF, cause LinkHandler don't support CRLF

    -- Init
    local formattedText = text
    -- Recheck setting if copy is disabled for chat dump
    if db.enablecopy then

        -- No CRLF
        -- ESO LUA Messages output \n instead of \r\n
        local crtext = string.gsub(text, "\r\n", "\n")
        -- Find multilines
        local cr = string.find(crtext, "\n")

        if not cr then
            formattedText = AddLinkHandlerToLine(text, chanCode, numLine)
        else
            local lines = {zo_strsplit("\n", crtext)}
            local first = true
            local strippedLine
            local numRows = 0

            for _, line in pairs(lines) do

                -- Only if there something to display
                if string.len(line) > 0 then

                    if first then
                        formattedText = AddLinkHandlerToLine(line, chanCode, numLine)
                        first = false
                    else
                        formattedText = formattedText .. "\n" .. AddLinkHandlerToLine(line, chanCode, numLine)
                    end

                    if numRows > 10 then
                        CHAT_SYSTEM:Zo_AddMessage("rChat has triggered 10 packed lines with text=" .. text .. "-- rChat - Message truncated")
                        return
                    else
                        numRows = numRows + 1
                    end

                end

            end

        end
    else
        formattedText = text
    end

    return formattedText

end

local function RestoreChatMessagesFromHistory(wasReloadUI)
    local function shouldRestore(channel)
        if channel~= CHAT_CHANNEL_SYSTEM and channel ~= CHAT_CHANNEL_WHISPER and channel ~=         CHAT_CHANNEL_WHISPER_SENT then
            return true
        end
        if channel == CHAT_CHANNEL_SYSTEM and (db.restoreSystem or db.restoreSystemOnly)then
            return true
        end
        if (channel == CHAT_CHANNEL_WHISPER or channel == CHAT_CHANNEL_WHISPER_SENT) and db.restoreWhisps then
            return true
        end
        return false
    end

    local categories = ZO_ChatSystem_GetEventCategoryMappings()
    local cattab = categories[EVENT_CHAT_MESSAGE_CHANNEL]

    local lastInsertionWas = 0
    for k,v in CACHE.iterCache() do
        if shouldRestore() and v.displayed then
            -- the only branch where we restore a line
            local category = cattab[v.channel]

            lastInsertionWas = math.max(lastInsertionWas, v.timestamp)
            local localPlayer = GetUnitName("player")
            for containerIndex, container in ipairs(CHAT_SYSTEM.containers) do
                for tabIndex, window in ipairs(container.windows) do
                    if IsChatContainerTabCategoryEnabled(container.id, tabIndex, category) then
                        if not db.chatConfSync[localPlayer].tabs[tabIndex].notBefore 
                                or v.timestamp > db.chatConfSync[localPlayer].tabs[tabIndex].notBefore then
                            container:AddEventMessageToWindow(window, v.displayed, category)
                        end
                    end
                end
            end

        end     -- end shouldRestore()

        local PRESSED = 1
        local UNPRESSED = 2
        for numTab, container in ipairs(CHAT_SYSTEM.primaryContainer.windows) do
            if numTab > 1 then
                CHAT_SYSTEM.primaryContainer:HandleTabClick(container.tab)
                local tabText = GetControl("ZO_ChatWindowTabTemplate" .. numTab .. "Text")
                tabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
                tabText:GetParent().state = PRESSED
                local oldTabText = GetControl("ZO_ChatWindowTabTemplate" .. numTab - 1 .. "Text")
                oldTabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_CONTRAST))
                oldTabText:GetParent().state = UNPRESSED
            end
        end

        local numTabs = #CHAT_SYSTEM.primaryContainer.windows
        if numTabs > 1 then
            CHAT_SYSTEM.primaryContainer:HandleTabClick(CHAT_SYSTEM.primaryContainer.windows[1].tab)
            local tabText = GetControl("ZO_ChatWindowTabTemplate1Text")
            tabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
            tabText:GetParent().state = PRESSED
            local oldTabText = GetControl("ZO_ChatWindowTabTemplate" .. #CHAT_SYSTEM.primaryContainer.windows .. "Text")
            oldTabText:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_CONTRAST))
            oldTabText:GetParent().state = UNPRESSED
        end

    end

    -- Restore TextEntry History
    if (wasReloadUI or db.restoreTextEntryHistoryAtLogOutQuit) and db.history.textEntry then

        if db.history.textEntry.entries then

            if lastInsertionWas and ((GetTimeStamp() - lastInsertionWas) < (db.timeBeforeRestore * HRS_TO_SEC)) then
                for _, text in pairs(db.history.textEntry.entries) do
                    CHAT_SYSTEM.textEntry:AddCommandHistory(text)
                end

                CHAT_SYSTEM.textEntry.commandHistory.index = db.history.textEntry.numEntries
            end

        end

    end

end

-- Restore History from SavedVars
local function RestoreChatHistory()

    -- Set default tab at login
    SetDefaultTab(db.defaultTab)
    -- Restore History
    if not db.history then
        rChat_ZOS.messagesWereRestored = true
        return
    end

    if db.lastWasReloadUI and db.restoreOnReloadUI then

        -- RestoreChannel
        if db.defaultchannel ~= RCHAT_CHANNEL_NONE then
            CHAT_SYSTEM:SetChannel(db.history.currentChannel, db.history.currentTarget)
        end

        -- restore TextEntry and Chat
        RestoreChatMessagesFromHistory(true)

    elseif (db.lastWasLogOut and db.restoreOnLogOut) or (db.lastWasAFK and db.restoreOnAFK) or (db.lastWasQuit and db.restoreOnQuit) then
        -- restore TextEntry and Chat
        RestoreChatMessagesFromHistory(false)
    end

    rChat_ZOS.messagesWereRestored = true

    local indexMessages = #rData.cachedMessages
    if indexMessages > 0 then
        local rmsg
        for index=1, indexMessages do
            rmsg = rData.cachedMessages[index]
            if rmsg and rmsg ~= "" then
                CHAT_SYSTEM:Zo_AddMessage(rData.cachedMessages[index])
            end
        end
    end

    db.lastWasReloadUI = false
    db.lastWasLogOut = false
    db.lastWasQuit = false
    db.lastWasAFK = true

end

-- Store line number
-- Create an array for the copy functions, spam functions and revert history functions
local function StorelineNumber(epochtime, rawFrom, text, chanCode, originalFrom, lineNum)

    -- Strip DDS tag from Copy text
    local function StripDDStags(text)
        return text:gsub("|t(.-)|t", "")
    end

    local msgPrefix = ""
    local rawText = text

    local entry,lineno = CACHE.getCacheEntry(lineNum)

    -- SysMessages does not have a from
    if chanCode ~= CHAT_CHANNEL_SYSTEM then

        -- Timestamp cannot be nil anymore with SpamFilter, so use the option itself
        if db.showTimestamp then
            -- Format for Copy
            msgPrefix = string.format("[%s] ",rChat.CreateTimestamp(db.timestampFormat))
        end

        -- Strip DDS tags for GM
        rawFrom = StripDDStags(rawFrom)

        -- Needed for SpamFilter
        entry.rawFrom = rawFrom

        -- msgPrefix is only rawFrom for now
        msgPrefix = msgPrefix .. rawFrom

        if db.carriageReturn then
            msgPrefix = msgPrefix .. "\n"
        end

    end

    -- Needed for SpamFilter & Restoration, UNIX timestamp
    entry.timestamp = epochtime

    -- Store CopyMessage / Used for SpamFiltering.
    entry.channel = chanCode

    -- Store CopyMessage
    entry.rawText = rawText

    -- Store CopyMessage
    entry.rawValue = text

    -- Strip DDS tags
    rawText = StripDDStags(rawText)

    -- Used to translate LinkHandlers
    rawText = rChat.FormatRawText(rawText)

    -- Store CopyMessage
    entry.rawMessage = rawText

    -- Store CopyLine
    entry.rawLine = msgPrefix .. rawText
end

-- WARNING : Since AddMessage is bypassed, this function and all its subfunctions DOES NOT CALL d() / Emitmessage() / AddMessage() or it will result an infinite loop and crash the game
-- Debug must call CHAT_SYSTEM:Zo_AddMessage() which is backed up copy of CHAT_SYSTEM.AddMessage
local function FormatSysMessage(statusMessage)

    if not statusMessage or string.len(statusMessage) == 0 then return end

    -- Display Timestamp if needed
    local function ShowTimestamp(timevalue)
        local timestr = ""

        -- Add timestamp
        if db.showTimestamp then
            -- Timestamp formatted
            timestr = rChat.CreateTimestamp(db.timestampFormat,timevalue)

            local timecol
            -- Timestamp color is chanCode so no coloring
            if db.timestampcolorislcol then
                timestr = string.format("[%s] ", timestr)
            else
                -- Timestamp color is our setting color
                timecol = db.colours.timestamp
                timestr = string.format("%s[%s] |r", timecol, timestr)
            end
        end
        return timestr
    end -- ShowTimestamp()


    local sysMessage

    -- Some addons are quicker than rChat
    if not db then return statusMessage end

    local entry, ndx = CACHE.getNewCacheEntry(CHAT_CHANNEL_SYSTEM)
    entry.rawValue = statusMessage
    entry.timestamp = GetTimeStamp()
    entry.rawTimestamp = ShowTimestamp(GetTimeString())

    -- Make it Linkable
    if db.enablecopy then
        sysMessage = entry.rawTimestamp..AddLinkHandler(statusMessage, CHAT_CHANNEL_SYSTEM, ndx)
    else
        sysMessage = entry.rawTimestamp..statusMessage
    end
    entry.displayed = sysMessage


    -- No From, rawTimestamp is in statusMessage, sent as arg for SpamFiltering even if SysMessages are not filtered
    StorelineNumber(entry.timestamp, nil, statusMessage, CHAT_CHANNEL_SYSTEM, nil, ndx)

    return sysMessage
end

-- Add a rChat handler for URL's
local function AddURLHandling(text, lineNum)

    -- handle complex URLs and do
    for pos, url, prot, subd, tld, colon, port, slash, path in text:gmatch("()(([%w_.~!*:@&+$/?%%#-]-)(%w[-.%w]*%.)(%w+)(:?)(%d*)(/?)([%w_.~!*:@&+$/?%#=-]*))") do
        if rData.protocols[prot:lower()] == (1 - #slash) * #path
        and (colon == "" or port ~= "" and port + 0 < 65536)
        and (rData.tlds[tld:lower()] or tld:find("^%d+$") and subd:find("^%d+%.%d+%.%d+%.$") and math.max(tld, subd:match("^(%d+)%.(%d+)%.(%d+)%.$")) < 256)
        and not subd:find("%W%W")
        then
            local urlHandled = string.format("|H1:%s:%s:%s|h%s|h", RCHAT_LINK, lineNum, RCHAT_URL_CHAN, url)
            url = url:gsub("([?+-])", "%%%1") -- don't understand why, 1st arg of gsub must be escaped and 2nd not.
            text, count = text:gsub(url, urlHandled)
        end
    end

    return text

end

local function InitializeURLHandling()

    -- cTLD + most used (> 0.1%)
    local domains =
    [[
    .ac.ad.ae.af.ag.ai.al.am.an.ao.aq.ar.as.at.au.aw.ax.az
    .ba.bb.bd.be.bf.bg.bh.bi.bj.bl.bm.bn.bo.bq.br.bs.bt.bv.bw.by.bz
    .ca.cc.cd.cf.cg.ch.ci.ck.cl.cm.cn.co.cr.cu.cv.cw.cx.cy.cz
    .de.dj.dk.dm.do.dz
    .ec.ee.eg.eh.er.es.et.eu.fi.fj.fk.fm.fo.fr
    .ga.gb.gd.ge.gf.gg.gh.gi.gl.gm.gn.gp.gq.gr.gs.gt.gu.gw.gy
    .hk.hm.hn.hr.ht.hu.id.ie.il.im.in.io.iq.ir.is.it
    .je.jm.jo.jp.ke.kg.kh.ki.km.kn.kp.kr.kw.ky.kz
    .la.lb.lc.li.lk.lr.ls.lt.lu.lv.ly
    .ma.mc.md.me.mf.mg.mh.mk.ml.mm.mn.mo.mp.mq.mr.ms.mt.mu.mv.mw.mx.my.mz
    .na.nc.ne.nf.ng.ni.nl.no.np.nr.nu.nz.om
    .pa.pe.pf.pg.ph.pk.pl.pm.pn.pr.ps.pt.pw.py.qa
    .re.ro.rs.ru.rw
    .sa.sb.sc.sd.se.sg.sh.si.sj.sk.sl.sm.sn.so.sr.ss.st.su.sv.sx.sy.sz
    .tc.td.tf.tg.th.tj.tk.tl.tm.tn.to.tp.tr.tt.tv.tw.tz
    .ua.ug.uk.um.us.uy.uz.va.vc.ve.vg.vi.vn.vu.wf.ws.ye.yt.za.zm.zw
    .biz.com.coop.edu.gov.int.mil.mobi.info.net.org.xyz.top.club.pro.asia
    ]]

    -- wxx.yy.zz
    rData.tlds = {}
    for tld in domains:gmatch('%w+') do
        rData.tlds[tld] = true
    end

    -- protos : only http/https
    rData.protocols = {['http://'] = 0, ['https://'] = 0}

end

-- decision tables for GetChannelColors()
local npc_channels = {
    [CHAT_CHANNEL_MONSTER_SAY] = true,
    [CHAT_CHANNEL_MONSTER_YELL] = true,
    [CHAT_CHANNEL_MONSTER_WHISPER] = true,
}
local guild_mem_channels = {
    [CHAT_CHANNEL_GUILD_1] = true,
    [CHAT_CHANNEL_GUILD_2] = true,
    [CHAT_CHANNEL_GUILD_3] = true,
    [CHAT_CHANNEL_GUILD_4] = true,
    [CHAT_CHANNEL_GUILD_5] = true,
}
local guild_ofc_channels = {
    [CHAT_CHANNEL_OFFICER_1] = true,
    [CHAT_CHANNEL_OFFICER_2] = true,
    [CHAT_CHANNEL_OFFICER_3] = true,
    [CHAT_CHANNEL_OFFICER_4] = true,
    [CHAT_CHANNEL_OFFICER_5] = true,
}
local lang_zone_channels = {
    [CHAT_CHANNEL_ZONE_LANGUAGE_1] = true,
    [CHAT_CHANNEL_ZONE_LANGUAGE_2] = true,
    [CHAT_CHANNEL_ZONE_LANGUAGE_3] = true,
    [CHAT_CHANNEL_ZONE_LANGUAGE_4] = true,
}

local function GetChannelColors(channel, from)

     -- Substract XX to a color (darker)
    local function FirstEsoColor(r, g, b)
        -- Scale is from 0-100 so divide per 300 will maximise difference at 0.33 (*2)
        r = math.max(r - (db.diffforESOcolors / 300 ),0)
        g = math.max(g - (db.diffforESOcolors / 300 ),0)
        b = math.max(b - (db.diffforESOcolors / 300 ),0)
        return r,g,b
    end

     -- Add XX to a color (brighter)
    local function SecondEsoColor(r, g, b)
        r = math.min(r + (db.diffforESOcolors / 300 ),1)
        g = math.min(g + (db.diffforESOcolors / 300 ),1)
        b = math.min(b + (db.diffforESOcolors / 300 ),1)
        return r,g,b
    end

    if db.useESOcolors then

        -- ESO actual color, return r,g,b
        local rESO, gESO, bESO
        -- Handle the same-colour options.
        if db.allNPCSameColour and npc_channels[channel] then
            rESO, gESO, bESO = ZO_ChatSystem_GetCategoryColorFromChannel(CHAT_CHANNEL_MONSTER_SAY)
        elseif db.allGuildsSameColour and guild_mem_channels[channel] then
            rESO, gESO, bESO = ZO_ChatSystem_GetCategoryColorFromChannel(CHAT_CHANNEL_GUILD_1)
        elseif db.allGuildsSameColour and guild_ofc_channels[channel] then
            rESO, gESO, bESO = ZO_ChatSystem_GetCategoryColorFromChannel(CHAT_CHANNEL_OFFICER_1)
        elseif db.allZonesSameColour and lang_zone_channels[channel] then
            rESO, gESO, bESO = ZO_ChatSystem_GetCategoryColorFromChannel(CHAT_CHANNEL_ZONE_LANGUAGE_1)
        elseif channel == CHAT_CHANNEL_PARTY and from and db.groupLeader
                and zo_strformat(SI_UNIT_NAME, from) == GetUnitName(GetGroupLeaderUnitTag()) then
            rESO, gESO, bESO = rChat.ConvertHexToRGBA(db.colours["groupleader"])
        else
            rESO, gESO, bESO = ZO_ChatSystem_GetCategoryColorFromChannel(channel)
        end

        -- Set right colour to left colour - cause ESO colors are rewritten; if onecolor, no rewriting
        if db.oneColour then
            lcol = rChat.ConvertRGBToHex(rESO, gESO, bESO)
            rcol = lcol
        else
            lcol = rChat.ConvertRGBToHex(FirstEsoColor(rESO,gESO,bESO))
            rcol = rChat.ConvertRGBToHex(SecondEsoColor(rESO,gESO,bESO))
        end

    else
        -- rChat Colors
        -- Handle the same-colour options.
        if db.allNPCSameColour and npc_channels[channel] then
            lcol, rcol = rChat.getColors(CHAT_CHANNEL_MONSTER_SAY)
        elseif db.allGuildsSameColour and guild_mem_channels[channel] then
            lcol, rcol = rChat.getColors(CHAT_CHANNEL_GUILD_1)
        elseif db.allGuildsSameColour and guild_ofc_channels[channel] then
            lcol, rcol = rChat.getColors(CHAT_CHANNEL_OFFICER_1)
        elseif db.allZonesSameColour and lang_zone_channels[channel] then
            lcol, rcol = rChat.getColors(CHAT_CHANNEL_ZONE)
        elseif channel == CHAT_CHANNEL_PARTY and from and db.groupLeader and zo_strformat(SI_UNIT_NAME, from) == GetUnitName(GetGroupLeaderUnitTag()) then
            lcol = db.colours["groupleader"]
            rcol = db.colours["groupleader1"]
        else
            lcol, rcol = rChat.getColors(channel)
        end

        -- Set right colour to left colour
        if db.oneColour then
            rcol = lcol
        end

    end

    return lcol, rcol

end

local function mentioned(text)
	if not db.mention.mentionEnabled then return false end
	if string.find(text,db.mention.mentionStr) then
		return true
	end
	return false
end

-- Executed when EVENT_CHAT_MESSAGE_CHANNEL triggers
-- Formats the message
--local function FormatMessage(chanCode, from, text, isCS, fromDisplayName, originalFrom, originalText, DDSBeforeAll, TextBeforeAll, DDSBeforeSender, TextBeforeSender, TextAfterSender, DDSAfterSender, DDSBeforeText, TextBeforeText, TextAfterText, DDSAfterText)
local function FormatMessage(chanCode, from, text, isCS, fromDisplayName)

    if not text or text == "nil" then return end
    if chanCode == nil or chanCode == "nil" then chanCode = 0 end
    fromDisplayName = fromDisplayName or from
    isCS = isCS or false
    local originalFrom = from
    local originalText = text
    local db = rChat.save

    -- Will calculate if this message is a spam
    local isSpam = rChat.SpamFilter(chanCode, from, text, isCS)
    if isSpam then return end

    -- Look for mentions
    local newtext = text
    if mentioned(text) then
    	if db.mention.colorEnabled then
    		newtext = string.gsub(text, db.mention.mentionStr, db.mention.colorizedMention)
    	end
    	if db.mention.soundEnabled then
    		-- play sound
    		SF.PlaySound(db.mention.sound)
    	end
    end

    -- Init message with other addons stuff
    local message = ""

    local entry, ndx = CACHE.getNewCacheEntry(chanCode)
    entry.rawFrom = from
    entry.rawValue = text           -- formatted message      
    entry.rawMessage = text         -- copy message
    entry.rawLine = newtext         -- copy line (prefix + message)
    entry.displayed = newtext    -- restored to chat (has link handler markers)

    local new_from, displayedFrom = ConvertName(chanCode, from, isCS, fromDisplayName)
    entry.cvtFrom = new_from

    -- Guild tag
    local guild_number, isOfc = GetGuildIndex(chanCode)
    local guild_name = rChat.SafeGetGuildName(guild_number)
    local tag
    if guild_number ~= 0 and not isOfc then
        tag = db.guildTags[guild_name]
        if tag and tag ~= "" then
            tag = tag
        else
            tag = guild_name
        end
    elseif guild_number ~= 0 and isOfc then
        local officertag = db.officertag[guild_name]
        if officertag and officertag ~= "" then
            tag = officertag
        else
            tag = guild_name
        end
    end

    -- Initialise colours
    local lcol, rcol = GetChannelColors(chanCode, from)

    -- Add timestamp
    if db.showTimestamp then

        -- Initialise timstamp color
        local timecol = db.colours.timestamp

        -- Timestamp color is lcol
        if db.timestampcolorislcol then
            timecol = lcol
        else
            -- Timestamp color is timestamp color
            timecol = db.colours.timestamp
        end

        -- Message is timestamp for now
        -- Add RCHAT_HANDLER for display
        local timestamp = rChat.LinkHandler_CreateLink( ndx, chanCode, rChat.CreateTimestamp(db.timestampFormat) ) .. " "

        -- Timestamp color
        message = message .. string.format("%s%s|r", timecol, timestamp)
        entry.rawValue = string.format("%s[%s] |r", timecol, rChat.CreateTimestamp(db.timestampFormat))
    end

    local linkedText = newtext

    -- Add URL Handling
    if db.urlHandling then
        text = AddURLHandling(newtext,ndx)
    end

    if db.enablecopy then
        linkedText = AddLinkHandler(newtext, chanCode, ndx)
    end

    local carriageReturn = ""
    if db.carriageReturn then
        carriageReturn = "\n"
    end

    local notHandled = false
    -- Standard format
    if chanCode == CHAT_CHANNEL_SAY or chanCode == CHAT_CHANNEL_YELL or chanCode == CHAT_CHANNEL_PARTY or chanCode == CHAT_CHANNEL_ZONE then
        -- Remove zone tags
        if db.delzonetags then

            -- Used for Copy
            entry.rawFrom = string.format(chatStrings.copystandard, entry.rawFrom)

            message = message .. string.format(chatStrings.standard, lcol, new_from, carriageReturn, rcol, linkedText)
            entry.rawValue = entry.rawValue .. string.format(chatStrings.standard, lcol, new_from, carriageReturn, rcol, text)
        -- Keep them
        else
            -- Init zonetag to keep the channel tag
            local zonetag
            -- Pattern for party is [Party]
            if chanCode == CHAT_CHANNEL_PARTY then
                zonetag = L(RCHAT_ZONETAGPARTY)

                -- Used for Copy
                entry.rawFrom = string.format(chatStrings.copyesoparty, zonetag, entry.rawFrom)

                -- PartyHandler
                zonetag = ZO_LinkHandler_CreateLink(zonetag, nil, CHANNEL_LINK_TYPE, chanCode)

                message = message .. string.format(chatStrings.esoparty, lcol, zonetag, new_from, carriageReturn, rcol, linkedText)
                entry.rawValue = entry.rawValue .. string.format(chatStrings.esoparty, lcol, zonetag, new_from, carriageReturn, rcol, text)
            else
                -- Pattern for say/yell/zone is "player says:" ..
                if chanCode == CHAT_CHANNEL_SAY then zonetag = L(RCHAT_ZONETAGSAY)
                elseif chanCode == CHAT_CHANNEL_YELL then zonetag = L(RCHAT_ZONETAGYELL)
                elseif chanCode == CHAT_CHANNEL_ZONE then zonetag = L(RCHAT_ZONETAGZONE)
                end

                -- Used for Copy
                entry.rawFrom = string.format(chatStrings.copyesostandard, entry.rawFrom, zonetag)

                -- rChat Handler
                --zonetag = rChat.LinkHandler_CreateLink(chanCode, zonetag)
                zonetag = string.format("|H1:p:%s|h%s|h", chanCode, zonetag)

                message = message .. string.format(chatStrings.esostandard, lcol, new_from, zonetag, carriageReturn, rcol, linkedText)
                entry.rawValue = entry.rawValue .. string.format(chatStrings.esostandard, lcol, new_from, zonetag, carriageReturn, rcol, newtext)
            end
        end

    -- NPC speech
    elseif chanCode == CHAT_CHANNEL_MONSTER_SAY or chanCode == CHAT_CHANNEL_MONSTER_YELL or chanCode == CHAT_CHANNEL_MONSTER_WHISPER then

        -- Used for Copy
        entry.rawFrom = string.format(chatStrings.copynpc, entry.rawFrom)

        message = message .. string.format(chatStrings.standard, lcol, new_from, carriageReturn, rcol, linkedText)
        entry.rawValue = entry.rawValue .. string.format(chatStrings.standard, lcol, new_from, carriageReturn, rcol, newtext)

    -- Incoming whispers
    elseif chanCode == CHAT_CHANNEL_WHISPER then

        --PlaySound
        if db.soundforincwhisps then
            SF.PlaySound(db.soundforincwhisps)
        end

        -- Used for Copy
        entry.rawFrom = string.format(chatStrings.copytellIn, entry.rawFrom)

        message = message .. string.format(chatStrings.tellIn, lcol, new_from, carriageReturn, rcol, linkedText)
        entry.rawValue = entry.rawValue .. string.format(chatStrings.tellIn, lcol, new_from, carriageReturn, rcol, newtext)

    -- Outgoing whispers
    elseif chanCode == CHAT_CHANNEL_WHISPER_SENT then

        -- Used for Copy
        entry.rawFrom = string.format(chatStrings.copytellOut, entry.rawFrom)

        message = message .. string.format(chatStrings.tellOut, lcol, new_from, carriageReturn, rcol, linkedText)
        entry.rawValue = entry.rawValue .. string.format(chatStrings.tellOut, lcol, new_from, carriageReturn, rcol, newtext)

    -- Guild chat
    elseif chanCode >= CHAT_CHANNEL_GUILD_1 and chanCode <= CHAT_CHANNEL_GUILD_5 then

        local gtag = tag
        local guild = GetGuildIndex(chanCode)
        if db.showGuildNumbers then
            gtag = guild .. "-" .. tag

            -- Used for Copy
            entry.rawFrom = string.format(chatStrings.copyguild, gtag, entry.rawFrom)

            -- GuildHandler
            gtag = ZO_LinkHandler_CreateLink(gtag, nil, CHANNEL_LINK_TYPE, chanCode)
            message = message .. string.format(chatStrings.guild, lcol, gtag, new_from, carriageReturn, rcol, linkedText)
            entry.rawValue = entry.rawValue .. string.format(chatStrings.guild, lcol, gtag, new_from, carriageReturn, rcol, newtext)

        else

            -- Used for Copy
            entry.rawFrom = string.format(chatStrings.copyguild, gtag, entry.rawFrom)

            -- GuildHandler
            gtag = ZO_LinkHandler_CreateLink(gtag, nil, CHANNEL_LINK_TYPE, chanCode)

            message = message .. string.format(chatStrings.guild, lcol, gtag, new_from, carriageReturn, rcol, linkedText)
            entry.rawValue = entry.rawValue .. string.format(chatStrings.guild, lcol, gtag, new_from, carriageReturn, rcol, newtext)

        end

    -- Officer chat
    elseif chanCode >= CHAT_CHANNEL_OFFICER_1 and chanCode <= CHAT_CHANNEL_OFFICER_5 then

        local gtag = tag
        if db.showGuildNumbers then
            gtag = (chanCode - CHAT_CHANNEL_OFFICER_1 + 1) .. "-" .. tag

            -- Used for Copy
            entry.rawFrom = string.format(chatStrings.copyguild, gtag, entry.rawFrom)

            -- GuildHandler
            gtag = ZO_LinkHandler_CreateLink(gtag, nil, CHANNEL_LINK_TYPE, chanCode)

            message = message .. string.format(chatStrings.guild, lcol, gtag, new_from, carriageReturn, rcol, linkedText)
            entry.rawValue = entry.rawValue .. string.format(chatStrings.guild, lcol, gtag, new_from, carriageReturn, rcol, newtext)

        else
            -- Used for Copy
            entry.rawFrom = string.format(chatStrings.copyguild, gtag, entry.rawFrom)

            -- GuildHandler
            gtag = ZO_LinkHandler_CreateLink(gtag, nil, CHANNEL_LINK_TYPE, chanCode)

            message = message .. string.format(chatStrings.guild, lcol, gtag, new_from, carriageReturn, rcol, linkedText)
            entry.rawValue = entry.rawValue .. string.format(chatStrings.guild, lcol, gtag, new_from, carriageReturn, rcol, newtext)
        end

    -- Player emotes
    elseif chanCode == CHAT_CHANNEL_EMOTE then

        entry.rawFrom = string.format(chatStrings.copyemote, entry.rawFrom)
        message = message .. string.format(chatStrings.emote, lcol, new_from, rcol, linkedText)
        entry.rawValue = entry.rawValue .. string.format(chatStrings.emote, lcol, new_from, rcol, newtext)

    -- NPC emotes
    elseif chanCode == CHAT_CHANNEL_MONSTER_EMOTE then

        -- Used for Copy
        entry.rawFrom = string.format(chatStrings.copyemote, entry.rawFrom)

        message = message .. string.format(chatStrings.emote, lcol, new_from, rcol, linkedText)
        entry.rawValue = entry.rawValue .. string.format(chatStrings.emote, lcol, new_from, rcol, newtext)

    -- Language zones
    elseif chanCode >= CHAT_CHANNEL_ZONE_LANGUAGE_1 and chanCode <= CHAT_CHANNEL_ZONE_LANGUAGE_4 then
        local lang
        if chanCode == CHAT_CHANNEL_ZONE_LANGUAGE_1 then lang = "EN"
        elseif chanCode == CHAT_CHANNEL_ZONE_LANGUAGE_2 then lang = "FR"
        elseif chanCode == CHAT_CHANNEL_ZONE_LANGUAGE_3 then lang = "DE"
        elseif chanCode == CHAT_CHANNEL_ZONE_LANGUAGE_4 then lang = "JP"
        end

        -- Used for Copy
        entry.rawFrom = string.format(chatStrings.copylanguage, lang, entry.rawFrom)

        message = message .. string.format(chatStrings.language, lcol, lang, new_from, carriageReturn, rcol, linkedText)
        entry.rawValue = entry.rawValue .. string.format(chatStrings.language, lcol, lang, new_from, carriageReturn, rcol, newtext)

    -- Unknown messages - just pass it through, no changes.
    else
        notHandled = true
        message = newtext
    end

    entry.displayed = message

    -- Only if handled by rChat

    if not notHandled then
        -- Store message and params into an array for copy system and SpamFiltering
        StorelineNumber(GetTimeStamp(), entry.rawFrom, newtext, chanCode, originalFrom, ndx)
    end

    if chanCode == CHAT_CHANNEL_WHISPER then
        OnIMReceived(displayedFrom, ndx)
    end

    return message

end

-- Save chat configuration
local function SaveChatConfig()

    if not rData.tabNotBefore then
        rData.tabNotBefore = {} -- Init here or in SyncChatConfig depending if the "Clear Tab" has been used
    end

    if isAddonLoaded and CHAT_SYSTEM and CHAT_SYSTEM.primaryContainer then -- Some addons calls SetCVar before

        local primeSettings = CHAT_SYSTEM.primaryContainer.settings
        local saveChar = {}

        -- Save Chat positions
        saveChar.relPoint = primeSettings.relPoint
        saveChar.x = primeSettings.x
        saveChar.y = primeSettings.y
        saveChar.height = primeSettings.height
        saveChar.width = primeSettings.width
        saveChar.point = primeSettings.point

        -- Don't overflow screen, remove 10px.
        if primeSettings.height >= ( CHAT_SYSTEM.maxContainerHeight - 15 ) then
            saveChar.height = ( CHAT_SYSTEM.maxContainerHeight - 15 )
        else
            saveChar.height = primeSettings.height
        end

        -- Same
        if primeSettings.width >= ( CHAT_SYSTEM.maxContainerWidth - 15 ) then
            saveChar.width = ( CHAT_SYSTEM.maxContainerWidth - 15 )
        else
            saveChar.width = primeSettings.width
        end

        -- Save Colors
        saveChar.colors = {}

        for _, category in ipairs (rData.chatCategories) do
            local r, g, b = GetChatCategoryColor(category)
            saveChar.colors[category] = { red = r, green = g, blue = b }
        end

        -- Save Font Size
        saveChar.fontSize = GetChatFontSize()

        -- Save Tabs
        saveChar.tabs = {}

        -- GetNumChatContainerTabs(1) don't refresh its number before a ReloadUI
        -- for numTab = 1, GetNumChatContainerTabs(1) do
        for numTab in ipairs (CHAT_SYSTEM.primaryContainer.windows) do

            local newtab = {
                isLocked = false,
                isInteractable = false,
                isCombatLog = false,
                areTimestampsEnabled = false,
                enabledCategories = {},
            }

            -- Save "Clear Tab" flag
            if rData.tabNotBefore[numTab] then
                newtab.notBefore = rData.tabNotBefore[numTab]
            end

            -- IsLocked
            if CHAT_SYSTEM.primaryContainer:IsLocked(numTab) then
                newtab.isLocked = true
            end

            -- IsInteractive
            if CHAT_SYSTEM.primaryContainer:IsInteractive(numTab) then
                newtab.isInteractable = true
            end

            -- IsCombatLog
            if CHAT_SYSTEM.primaryContainer:IsCombatLog(numTab) then
                newtab.isCombatLog = true
                -- AreTimestampsEnabled
                if CHAT_SYSTEM.primaryContainer:AreTimestampsEnabled(numTab) then
                    newtab.areTimestampsEnabled = true
                end
            end

            -- GetTabName
            newtab.name = CHAT_SYSTEM.primaryContainer:GetTabName(numTab)

            -- Enabled categories
            for _, category in ipairs (rData.chatCategories) do
                local isEnabled = IsChatContainerTabCategoryEnabled(1, numTab, category)
                newtab.enabledCategories[category] = isEnabled
            end
            -- save tab config
            saveChar.tabs[numTab] = newtab
        end

        -- Rewrite the whole char tab
        db.chatConfSync[GetUnitName("player")] = saveChar
        db.chatConfSync.lastChar = saveChar

    end

end

-- Save Chat Tabs config when user changes it
local function SaveTabsCategories()

    local localPlayer = GetUnitName("player")
    for numTab in ipairs (CHAT_SYSTEM.primaryContainer.windows) do

        for _, category in ipairs (rData.guildCategories) do
            local isEnabled = IsChatContainerTabCategoryEnabled(1, numTab, category)
            if db.chatConfSync[localPlayer].tabs[numTab] then
                db.chatConfSync[localPlayer].tabs[numTab].enabledCategories[category] = isEnabled
            else
                SaveChatConfig()
            end
        end

    end

end

-- Function for Minimizing chat at launch
local function MinimizeChatAtLaunch()
    if db.chatMinimizedAtLaunch then
        CHAT_SYSTEM:Minimize()
    end
end

local function MinimizeChatInMenus()

    -- RegisterCallback for Maximize/Minimize chat when entering/leaving scenes
    -- "hud" is base scene (with "hudui")
    local hudScene = SCENE_MANAGER:GetScene("hud")
    hudScene:RegisterCallback("StateChange", function(oldState, newState)

        if db.chatMinimizedInMenus then
            if newState == SCENE_HIDDEN and SCENE_MANAGER:GetNextScene():GetName() ~= "hudui" then
                CHAT_SYSTEM:Minimize()
            end
        end

        if db.chatMaximizedAfterMenus then
            if newState == SCENE_SHOWING then
                CHAT_SYSTEM:Maximize()
            end
        end

    end)

end

-- Import the chat config from rChat settings
local function SyncChatConfig(shouldSync, whichChar)

    if not shouldSync then return end   -- why call this if you don't want to import stuff?
    if not db.chatConfSync then return end
    if not db.chatConfSync[whichChar] then return end   -- no character config to use

    local newcfg = db.chatConfSync[whichChar]

    -- Position and width/height
    CHAT_SYSTEM.control:SetAnchor(newcfg.point, GuiRoot, newcfg.relPoint, newcfg.x, newcfg.y)
    -- Height / Width
    CHAT_SYSTEM.control:SetDimensions(newcfg.width, newcfg.height)

    -- Save settings immediately (to check, maybe call function which do this)
    local primeSettings = CHAT_SYSTEM.primaryContainer.settings
    primeSettings.height = newcfg.height
    primeSettings.point = newcfg.point
    primeSettings.relPoint = newcfg.relPoint
    primeSettings.width = newcfg.width
    primeSettings.x = newcfg.x
    primeSettings.y = newcfg.y

    -- Colors
    for _, category in ipairs (rData.chatCategories) do
        if not newcfg.colors[category] then
            local r, g, b = GetChatCategoryColor(category)
            newcfg.colors[category] = { red = r, green = g, blue = b }
        end
        SetChatCategoryColor(category, newcfg.colors[category].red, newcfg.colors[category].green, newcfg.colors[category].blue)
    end

    -- Font Size
    local fontSize = newcfg.fontSize
    CHAT_SYSTEM:SetFontSize(fontSize)
    SetChatFontSize(fontSize)
    local chatSyncNumTab = 1

    for numTab in ipairs(newcfg.tabs) do

        --Create a Tab if nessesary
        if (GetNumChatContainerTabs(1) < numTab) then
            -- AddChatContainerTab() -- Requires a ReloadUI
            CHAT_SYSTEM.primaryContainer:AddWindow(newcfg.tabs[numTab].name)
        end

        if newcfg.tabs[numTab] and newcfg.tabs[numTab].notBefore then
            if not rData.tabNotBefore then
                rData.tabNotBefore = {} -- Used for tab restoration, init here.
            end
            rData.tabNotBefore[numTab] = newcfg.tabs[numTab].notBefore
        end

        CHAT_SYSTEM.primaryContainer:SetTabName(numTab, newcfg.tabs[numTab].name)
        CHAT_SYSTEM.primaryContainer:SetLocked(numTab, newcfg.tabs[numTab].isLocked)
        CHAT_SYSTEM.primaryContainer:SetInteractivity(numTab, newcfg.tabs[numTab].isInteractable)
        CHAT_SYSTEM.primaryContainer:SetTimestampsEnabled(numTab, newcfg.tabs[numTab].areTimestampsEnabled)

        -- Set Channel per tab configuration
        for _, category in ipairs (rData.chatCategories) do
            if newcfg.tabs[numTab].enabledCategories[category] == nil then -- Can be false
                newcfg.tabs[numTab].enabledCategories[category] = IsChatContainerTabCategoryEnabled(1, numTab, category)
            end
            SetChatContainerTabCategoryEnabled(1, numTab, category, newcfg.tabs[numTab].enabledCategories[category])
        end

        chatSyncNumTab = numTab

    end

    -- If they're was too many tabs before, drop them
    local removeTabs = true
    while removeTabs do
        -- Too many tabs, deleting one
        if GetNumChatContainerTabs(1) > chatSyncNumTab then
            -- Not in realtime : RemoveChatContainerTab(1, chatSyncNumTab + 1)
            CHAT_SYSTEM.primaryContainer:RemoveWindow(chatSyncNumTab + 1, nil)
        else
            removeTabs = false
        end
    end
end

-- When creating a char, try to import settings
local function AutoSyncSettingsForNewPlayer()

    -- New chars get automaticaly last char config
    if GetIsNewCharacter() then
        SyncChatConfig(true, "lastChar")
    end

end

-- Set channel to the default one
local function SetToDefaultChannel()
    if db.defaultchannel ~= RCHAT_CHANNEL_NONE then
        CHAT_SYSTEM:SetChannel(db.defaultchannel)
    end
end

-- Create guildname to guild index table
local function SaveGuildIndexes()

    rData.guildIndexes = {}
    for guild = 1, GetNumGuilds() do
        local guildName = rChat.SafeGetGuildName(guild)
        rData.guildIndexes[guildName] = guild
    end

end

-- Executed when EVENT_IGNORE_ADDED triggers
local function OnIgnoreAdded(displayName)

    -- DisplayName is linkable
    local displayNameLink = ZO_LinkHandler_CreateDisplayNameLink(displayName)
    local statusMessage = zo_strformat(SI_FRIENDS_LIST_IGNORE_ADDED, displayNameLink)

    -- Only if statusMessage is set
    if statusMessage then
        -- added to ignore list
        return FormatSysMessage(statusMessage)
    end

end

-- Executed when EVENT_IGNORE_REMOVED triggers
local function OnIgnoreRemoved(displayName)

    -- DisplayName is linkable
    local displayNameLink = ZO_LinkHandler_CreateDisplayNameLink(displayName)
    local statusMessage = zo_strformat(SI_FRIENDS_LIST_IGNORE_REMOVED, displayNameLink)

    -- Only if statusMessage is set
    if statusMessage then
        -- removed from ignore list
        return FormatSysMessage(statusMessage)
    end

end

-- triggers when EVENT_FRIEND_PLAYER_STATUS_CHANGED
local function OnFriendPlayerStatusChanged(displayName, characterName, oldStatus, newStatus)

    local statusMessage

    -- DisplayName is linkable
    local displayNameLink = ZO_LinkHandler_CreateDisplayNameLink(displayName)
    -- CharacterName is linkable
    local characterNameLink = ZO_LinkHandler_CreateCharacterLink(characterName)

    local wasOnline = oldStatus ~= PLAYER_STATUS_OFFLINE
    local isOnline = newStatus ~= PLAYER_STATUS_OFFLINE

    -- Not connected before and Connected now (no messages for Away/Busy)
    if not wasOnline and isOnline then
        -- Return
        -- friend has logged on with toon
        statusMessage = zo_strformat(SI_FRIENDS_LIST_FRIEND_CHARACTER_LOGGED_ON, displayNameLink, characterNameLink)
    -- Connected before and Offline now
    elseif wasOnline and not isOnline then
        -- friend has logged off with toon
        statusMessage = zo_strformat(SI_FRIENDS_LIST_FRIEND_CHARACTER_LOGGED_OFF, displayNameLink, characterNameLink)
    end

    -- Only if statusMessage is set
    if statusMessage then
        return FormatSysMessage(statusMessage)
    end

end

-- Executed when EVENT_GROUP_TYPE_CHANGED triggers
local function OnGroupTypeChanged(largeGroup)

    if largeGroup then
        -- Your group is now a large group
        return FormatSysMessage(L(SI_CHAT_ANNOUNCEMENT_IN_LARGE_GROUP))
    else
        -- Your group is no longer a large group
        return FormatSysMessage(L(SI_CHAT_ANNOUNCEMENT_IN_SMALL_GROUP))
    end

end

local function OnGroupMemberLeftLC(_, reason, isLocalPlayer, _, _, actionRequiredVote)
    if reason == GROUP_LEAVE_REASON_KICKED and isLocalPlayer and actionRequiredVote then
        -- Your group members voted to kick you from the group
        return L(SI_GROUP_ELECTION_KICK_PLAYER_PASSED)
    end
end

local function UpdateGuildSwitches()

    -- Each guild
    local ChanInfoArray = ZO_ChatSystem_GetChannelInfo()
    local guildName, guildId
    for i = 1, GetNumGuilds() do

        guildName, guildId = rChat.SafeGetGuildName(i)
        if guildId then
            local mem, ofc = GetGuildChannel(i)
            -- Get saved string
            local switch = db.switchFor[guildName]
            if switch and switch ~= "" then
                switch = switch .. " " .. L(SI_CHANNEL_SWITCH_GUILD_1 - 1 + i)
            else
                switch = L(SI_CHANNEL_SWITCH_GUILD_1 - 1 + i)
            end
            ChanInfoArray[mem].switches = switch

            -- Get saved string
            local officerSwitch = db.officerSwitchFor[guildName]
            if officerSwitch and officerSwitch ~= "" then
                officerSwitch = officerSwitch .. " " .. L(SI_CHANNEL_SWITCH_OFFICER_1 - 1 + i)  
            else
                officerSwitch = L(SI_CHANNEL_SWITCH_OFFICER_1 - 1 + i)
            end
            ChanInfoArray[ofc].switches = officerSwitch
        end

    end

end

-- *********************************************************************************
-- * Section: LAM Outside Functions : used in LAM but function resides outside LAM
-- *********************************************************************************
-- Character Sync
local function SyncCharacterSelectChoices()
    local localPlayer = GetUnitName("player")
    -- Sync Character Select
    rData.chatConfSyncChoices = {}
    if db.chatConfSync then
        for names, tagada in pairs (db.chatConfSync) do
            if names ~= "lastChar" then
                table.insert(rData.chatConfSyncChoices, names)
            end
        end
    else
        table.insert(rData.chatConfSyncChoices, localPlayer)
    end
end


-- *********************************************************************************
-- * Section: Settings Start (LAM)
-- *********************************************************************************
-- Build LAM Option Table, used when AddonLoads or when a player join/leave a guild
local function BuildLAMPanel()

    -- Used to reset colors to default value, lam need a formatted array
    -- LAM Message Settings
    local localPlayer = GetUnitName("player")
    local fontsDefined = LMP:List('font')

        -- Sync Character Select
    rData.chatConfSyncChoices = {}
    if db.chatConfSync then
        for names, tagada in pairs (db.chatConfSync) do
            if names ~= "lastChar" then
                table.insert(rData.chatConfSyncChoices, names)
            end
        end
    else
        table.insert(rData.chatConfSyncChoices, localPlayer)
    end

    -- CHAT_SYSTEM.primaryContainer.windows doesn't exists yet at OnAddonLoaded. So using the rChat reference.
    local arrayTab = {}
    if db.chatConfSync and db.chatConfSync[localPlayer] and db.chatConfSync[localPlayer].tabs then
        for numTab, data in pairs (db.chatConfSync[localPlayer].tabs) do
            table.insert(arrayTab, numTab)
        end
    else
        table.insert(arrayTab, 1)
    end

    getTabNames()

    local optionsData = {}

    -- Messages Settings
    optionsData[#optionsData + 1] = {
        type = "submenu",
        name = SF.GetIconized(RCHAT_OPTIONSH, SF.hex.bronze),
        controls = {
            {-- LAM Option Remove Zone Tags
                type = "checkbox",
                name = L(RCHAT_DELZONETAGS),
                tooltip = L(RCHAT_DELZONETAGSTT),
                getFunc = function() return db.delzonetags end,
                setFunc = function(newValue) db.delzonetags = newValue end,
                width = "full",
                default = defaults.delzonetags,
            },
            {
                type = "header",
                name = SF.GetIconized(RCHAT_GEOCHANNELSFORMAT, SF.hex.superior),
                width = "full",
            },
            {
                type = "description",
                text = "",
            },
            {-- LAM Option Newline between name and message
                type = "checkbox",
                name = L(RCHAT_CARRIAGERETURN),
                tooltip = L(RCHAT_CARRIAGERETURNTT),
                getFunc = function() return db.carriageReturn end,
                setFunc = function(newValue) db.carriageReturn = newValue end,
                width = "full",
                default = defaults.carriageReturn,
            },
            {-- LAM Option Names Format
                type = "dropdown",
                name = L(RCHAT_GEOCHANNELSFORMAT),
                tooltip = L(RCHAT_GEOCHANNELSFORMATTT),
                choices = {L("RCHAT_GROUPNAMESCHOICE", 1), L("RCHAT_GROUPNAMESCHOICE", 2), L("RCHAT_GROUPNAMESCHOICE", 3)}, -- Same as group.
                width = "half",
                default = defaults.geoChannelsFormat,
                getFunc = function() return L("RCHAT_GROUPNAMESCHOICE", db.geoChannelsFormat) end,
                setFunc = function(choice)
                    if choice == L("RCHAT_GROUPNAMESCHOICE", 1) then
                        db.geoChannelsFormat = 1
                    elseif choice == L("RCHAT_GROUPNAMESCHOICE", 2) then
                        db.geoChannelsFormat = 2
                    elseif choice == L("RCHAT_GROUPNAMESCHOICE", 3) then
                        db.geoChannelsFormat = 3
                    else
                        -- When clicking on LAM default button
                        db.geoChannelsFormat = defaults.geoChannelsFormat
                    end

                end,
            },
            {-- Disable Brackets
                type = "checkbox",
                name = L(RCHAT_DISABLEBRACKETS),
                tooltip = L(RCHAT_DISABLEBRACKETSTT),
                getFunc = function() return db.disableBrackets end,
                setFunc = function(newValue) 
                    db.disableBrackets = newValue 
                    if db.disableBrackets then
                        chatStrings = chatStrings_nobrackets
                    else
                        chatStrings = chatStrings_brackets
                    end
                end,
                width = "half",
                default = defaults.disableBrackets,
            },
            {
                type = "editbox",
                name = L(RCHAT_NICKNAMES),
                tooltip = L(RCHAT_NICKNAMESTT),
                isMultiline = true,
                isExtraWide = true,
                getFunc = function() return db.nicknames end,
                setFunc = function(newValue)
                    db.nicknames = newValue
                    BuildNicknames(true) -- Rebuild the control if data is invalid
                end,
                width = "full",
                default = defaults.nicknames,
            },
            {
                type = "header",
                name = SF.GetIconized(RCHAT_TIMESTAMPH, SF.hex.superior),
                width = "full",
            },
            {
                type = "description",
                text = "",
            },
            {
                type = "checkbox",
                name = L(RCHAT_ENABLETIMESTAMP),
                tooltip = L(RCHAT_ENABLETIMESTAMPTT),
                getFunc = function() return db.showTimestamp end,
                setFunc = function(newValue) db.showTimestamp = newValue end,
                width = "full",
                default = defaults.showTimestamp,
            },
            {
                type = "editbox",
                name = L(RCHAT_TIMESTAMPFORMAT),
                tooltip = L(RCHAT_TIMESTAMPFORMATTT),
                getFunc = function() return db.timestampFormat end,
                setFunc = function(newValue) db.timestampFormat = newValue end,
                width = "full",
                default = defaults.timestampFormat,
                disabled = function() return not db.showTimestamp end,
            },
            {
                type = "checkbox",
                name = L(RCHAT_TIMESTAMPCOLORISLCOL),
                tooltip = L(RCHAT_TIMESTAMPCOLORISLCOLTT),
                getFunc = function() return db.timestampcolorislcol end,
                setFunc = function(newValue) db.timestampcolorislcol = newValue end,
                width = "full",
                default = defaults.timestampcolorislcol,
                disabled = function() return not db.showTimestamp end,
            },
            {
                type = "colorpicker",
                name = L(RCHAT_TIMESTAMP),
                tooltip = L(RCHAT_TIMESTAMPTT),
                getFunc = function() return rChat.ConvertHexToRGBA(db.colours.timestamp) end,
                setFunc = function(r, g, b) db.colours.timestamp = rChat.ConvertRGBToHex(r, g, b) end,
                default = rChat.ConvertHexToRGBAPacked(defaults.colours["timestamp"]),
                disabled = function()
                    if not db.showTimestamp then return true end
                    if db.timestampcolorislcol then return true end
                    return false end,
            },
            -- mention Section
			{
				type = "header",
				name = SF.GetIconized(RCHAT_MENTION_NM, SF.hex.superior), -- or string id or function returning a string
				width = "full", --or "half" (optional)
			},
			{
				type = "checkbox",
				name = GetString(RCHAT_MENTION_ENABLED),
				getFunc = function() return db.mention.mentionEnabled end,
				setFunc = function(value) db.mention.mentionEnabled = value end,
				width = "full",
			},
            {
                type = "editbox",
                name = L(RCHAT_MENTIONSTR),
                --tooltip = L(RCHAT_MENTIONSTRTT),
                getFunc = function() return db.mention.mentionStr end,
                setFunc = function(newValue)
                		if string.len(newValue) < 4 then
                			db.mention.mentionStr = ""
                            db.mention.colorizedMention = ""
                			return
                		end
                		if nil == string.find(newValue, "[%%%*%-%.%+%(%)%[%]%^%$%?]") then
							db.mention.mentionStr = newValue
                            if db.mention.colorEnabled then
                                db.mention.colorizedMention = string.format("%s%s|r", db.mention.color,newValue)
                            else
                                db.mention.colorizedMention = newValue
                            end
						else
							db.mention.mentionStr = newValue
                            db.mention.colorizedMention = newValue
						end
					end,
                width = "full",
                default = defaults.mention.mentionStr,
                disabled = function() return not db.mention.mentionEnabled end,
            },
			{
				type = "checkbox",
				name = GetString(RCHAT_SOUND_ENABLED),
				getFunc = function() return db.mention.soundEnabled end,
				setFunc = function(value) db.mention.soundEnabled = value end,
				disabled = function() return not db.mention.mentionEnabled end,
				width = "half",
			},
            {-- Mentions: Sound
                type = "slider",
                name = GetString(RCHAT_SOUND_INDEX),
                min = 1, max = SF.numSounds(), step = 1,
                getFunc = function()
                    if type(db.mention.sound) == "string" then
                        return SF.getSoundIndex(db.mention.sound)
                    end
                    return SF.getSoundIndex(defaults.mention.sound)
                end,
                setFunc = function(value)
                    db.mention.sound = SF.getSound(value)
                    local ctrl = WINDOW_MANAGER:GetControlByName("RCHAT_MENTION_SOUND")
                    if ctrl ~= nil then
                        ctrl.data.text = SF.ColorText(db.mention.sound, SF.hex.normal)
                    end
                    SF.PlaySound(db.mention.sound)
                end,
                width = "half",
                disabled = function() return not db.mention.mentionEnabled end,
                default = defaults.mention.sound,
            },
            {
                type = "description",
                title = L(RCHAT_SOUND_NAME),
                text = SF.ColorText(db.mention.sound, SF.hex.normal),
                disable = false,
                reference = "RCHAT_MENTION_SOUND",
            },
			{ -- Mention color enabled
				type = "checkbox",
				name = GetString(RCHAT_COLOR_ENABLED),
				getFunc = function() return db.mention.colorEnabled end,
				setFunc = function(value) db.mention.colorEnabled = value end,
				disabled = function() return not db.mention.mentionEnabled end,
				width = "half",
			},
            {-- Mention Color
                type = "colorpicker",
                name = L(RCHAT_MENTIONCOLOR),
                --tooltip = L(RCHAT_MENTIONCOLORTT),
                getFunc = function() return rChat.ConvertHexToRGBA(db.mention.color) end,
                setFunc = function(r, g, b)
                    db.mention.color = rChat.ConvertRGBToHex(r, g, b)
                    if not db.mention.mentionStr then
                        db.mention.mentionStr = ""
                        db.mention.colorizedMention = ""
                    elseif db.mention.colorEnabled then
                        db.mention.colorizedMention = string.format("%s%s|r", db.mention.color,
                            db.mention.mentionStr)
                    else
                        db.mention.colorizedMention = db.mention.mentionStr
                    end
                end,
                width = "half",
                default = rChat.ConvertHexToRGBAPacked(defaults.mention.color),
                disabled = function() return not db.mention.colorEnabled end,
            },
            {
                type = "header",
                name = SF.GetIconized("Misc", SF.hex.superior),
                width = "full",
            },
            {
                type = "description",
                text = "",
            },
            {-- LAM Option Guild Tags next to entry box
                type = "checkbox",
                name = L(RCHAT_GUILDTAGSNEXTTOENTRYBOX),
                tooltip = L(RCHAT_GUILDTAGSNEXTTOENTRYBOXTT),
                width = "full",
                default = defaults.showTagInEntry,
                getFunc = function() return db.showTagInEntry end,
                setFunc = function(newValue)
                            db.showTagInEntry = newValue
                            UpdateGuildChannelNames()
                        end
            },
            {--Target History
                type = "checkbox",
                name = L(RCHAT_ADDCHANNELANDTARGETTOHISTORY),
                tooltip = L(RCHAT_ADDCHANNELANDTARGETTOHISTORYTT),
                getFunc = function() return db.addChannelAndTargetToHistory end,
                setFunc = function(newValue) db.addChannelAndTargetToHistory = newValue end,
                width = "full",
                default = defaults.addChannelAndTargetToHistory,
            },
            {-- URL is clickable
                type = "checkbox",
                name = L(RCHAT_URLHANDLING),
                tooltip = L(RCHAT_URLHANDLINGTT),
                getFunc = function() return db.urlHandling end,
                setFunc = function(newValue) db.urlHandling = newValue end,
                width = "full",
                default = defaults.urlHandling,
            },
        },
    }
    -- Chat Tabs
    optionsData[#optionsData + 1] = {
        type = "submenu",
        name = SF.GetIconized(RCHAT_CHATTABH, SF.hex.bronze),
        controls = {
            {-- Enable chat channel memory
                type = "checkbox",
                name = L(RCHAT_enableChatTabChannel),
                tooltip = L(RCHAT_enableChatTabChannelT),
                getFunc = function() return db.enableChatTabChannel end,
                setFunc = function(newValue) db.enableChatTabChannel = newValue end,
                width = "full",
                default = defaults.enableChatTabChannel,
            },
            {-- TODO : optimize
                type = "dropdown",
                name = L(RCHAT_DEFAULTCHANNEL),
                tooltip = L(RCHAT_DEFAULTCHANNELTT),
                --choices = chatTabNames,
                choices = {
                    L("RCHAT_DEFAULTCHANNELCHOICE", RCHAT_CHANNEL_NONE),
                    L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_ZONE),
                    L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_SAY),
                    L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_1),
                    L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_2),
                    L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_3),
                    L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_4),
                    L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_5),
                    L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_1),
                    L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_2),
                    L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_3),
                    L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_4),
                    L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_5)
                },
                width = "full",
                default = defaults.defaultchannel,
                getFunc = function() return L("RCHAT_DEFAULTCHANNELCHOICE", db.defaultchannel) end,
                setFunc = function(choice)
                    if choice == L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_ZONE) then
                        db.defaultchannel = CHAT_CHANNEL_ZONE
                    elseif choice == L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_SAY) then
                        db.defaultchannel = CHAT_CHANNEL_SAY
                    elseif choice == L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_1) then
                        db.defaultchannel = CHAT_CHANNEL_GUILD_1
                    elseif choice == L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_2) then
                        db.defaultchannel = CHAT_CHANNEL_GUILD_2
                    elseif choice == L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_3) then
                        db.defaultchannel = CHAT_CHANNEL_GUILD_3
                    elseif choice == L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_4) then
                        db.defaultchannel = CHAT_CHANNEL_GUILD_4
                    elseif choice == L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_GUILD_5) then
                        db.defaultchannel = CHAT_CHANNEL_GUILD_5
                    elseif choice == L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_1) then
                        db.defaultchannel = CHAT_CHANNEL_OFFICER_1
                    elseif choice == L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_2) then
                        db.defaultchannel = CHAT_CHANNEL_OFFICER_2
                    elseif choice == L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_3) then
                        db.defaultchannel = CHAT_CHANNEL_OFFICER_3
                    elseif choice == L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_4) then
                        db.defaultchannel = CHAT_CHANNEL_OFFICER_4
                    elseif choice == L("RCHAT_DEFAULTCHANNELCHOICE", CHAT_CHANNEL_OFFICER_5) then
                        db.defaultchannel = CHAT_CHANNEL_OFFICER_5
                    elseif choice == L("RCHAT_DEFAULTCHANNELCHOICE", RCHAT_CHANNEL_NONE) then
                        db.defaultchannel = RCHAT_CHANNEL_NONE
                    else
                        -- When user click on LAM reinit button
                        db.defaultchannel = defaults.defaultchannel
                    end

                end,
            },
            {-- CHAT_SYSTEM.primaryContainer.windows doesn't exist yet at OnAddonLoaded. So using the rChat reference.
                type = "dropdown",
                name = L(RCHAT_DEFAULTTAB),
                tooltip = L(RCHAT_DEFAULTTABTT),
                choices = rChat.tabNames,
                width = "full",
                getFunc = function() return db.defaultTabName end,
                setFunc = function(choice)
                        db.defaultTabName = choice
                        db.defaultTab = getTabIdx(choice)
                    end,
            },
            {-- New Message Color
                type = "colorpicker",
                name = L(RCHAT_TABWARNING),
                tooltip = L(RCHAT_TABWARNINGTT),
                getFunc = function() return rChat.ConvertHexToRGBA(db.colours["tabwarning"]) end,
                setFunc = function(r, g, b)
                        db.colours["tabwarning"] = rChat.ConvertRGBToHex(r, g, b)
                    end,
                default = rChat.ConvertHexToRGBAPacked(defaults.colours["tabwarning"]),
            },
        },
    }
    -- Group Submenu
    optionsData[#optionsData + 1] = {
        type = "submenu",
        name = SF.GetIconized(RCHAT_GROUPH, SF.hex.bronze),
        controls = {
            {-- Enable Party Switch
                type = "checkbox",
                name = L(RCHAT_ENABLEPARTYSWITCH),
                tooltip = L(RCHAT_ENABLEPARTYSWITCHTT),
                getFunc = function() return db.enablepartyswitch end,
                setFunc = function(newValue) db.enablepartyswitch = newValue end,
                width = "full",
                default = defaults.enablepartyswitch,
            },
            {-- Group Names
                type = "dropdown",
                name = L(RCHAT_GROUPNAMES),
                tooltip = L(RCHAT_GROUPNAMESTT),
                choices = {L("RCHAT_GROUPNAMESCHOICE", 1), L("RCHAT_GROUPNAMESCHOICE", 2), L("RCHAT_GROUPNAMESCHOICE", 3)},
                width = "full",
                default = defaults.groupNames,
                getFunc = function() return L("RCHAT_GROUPNAMESCHOICE", db.groupNames) end,
                setFunc = function(choice)
                    if choice == L("RCHAT_GROUPNAMESCHOICE", 1) then
                        db.groupNames = 1
                    elseif choice == L("RCHAT_GROUPNAMESCHOICE", 2) then
                        db.groupNames = 2
                    elseif choice == L("RCHAT_GROUPNAMESCHOICE", 3) then
                        db.groupNames = 3
                    else
                        -- When clicking on LAM default button
                        db.groupNames = defaults.groupNames
                    end

                end,
            },
            {-- Group Leader
                type = "checkbox",
                name = L(RCHAT_GROUPLEADER),
                tooltip = L(RCHAT_GROUPLEADERTT),
                getFunc = function() return db.groupLeader end,
                setFunc = function(newValue) db.groupLeader = newValue end,
                width = "full",
                default = defaults.groupLeader,
            },
            {-- Group Leader Color
                type = "colorpicker",
                name = L(RCHAT_GROUPLEADERCOLOR),
                tooltip = L(RCHAT_GROUPLEADERCOLORTT),
                getFunc = function() return rChat.ConvertHexToRGBA(db.colours["groupleader"]) end,
                setFunc = function(r, g, b) db.colours["groupleader"] = rChat.ConvertRGBToHex(r, g, b) end,
                width = "half",
                default = rChat.ConvertHexToRGBAPacked(defaults.colours["groupleader"]),
                disabled = function() return not db.groupLeader end,
            },
            {-- Group Leader Color 2
                type = "colorpicker",
                name = L(RCHAT_GROUPLEADERCOLOR1),
                tooltip = L(RCHAT_GROUPLEADERCOLOR1TT),
                getFunc = function()
                        return rChat.ConvertHexToRGBA(db.colours["groupleader1"])
                    end,
                setFunc = function(r, g, b)
                        db.colours["groupleader1"] = rChat.ConvertRGBToHex(r, g, b)
                    end,
                width = "half",
                default = rChat.ConvertHexToRGBAPacked(defaults.colours["groupleader1"]),
                disabled = function()
                        if not db.groupLeader then
                            return true
                        elseif db.useESOcolors then
                            return true
                        else
                            return false
                        end
                    end,
            },
        },
    }
    -- Sync Settings Header
    optionsData[#optionsData + 1] = {
        type = "submenu",
        name = SF.GetIconized(RCHAT_SYNCH, SF.hex.bronze),
        controls = {
            {-- Sync ON
                type = "checkbox",
                name = L(RCHAT_CHATSYNCCONFIG),
                tooltip = L(RCHAT_CHATSYNCCONFIGTT),
                getFunc = function() return db.chatSyncConfig end,
                setFunc = function(newValue) db.chatSyncConfig = newValue end,
                width = "full",
                default = defaults.chatSyncConfig,
            },
            {-- Config Import From
                type = "dropdown",
                name = L(RCHAT_CHATSYNCCONFIGIMPORTFROM),
                tooltip = L(RCHAT_CHATSYNCCONFIGIMPORTFROMTT),
                choices = rData.chatConfSyncChoices,
                width = "full",
                getFunc = function() return GetUnitName("player") end,
                setFunc = function(choice)
                    SyncChatConfig(true, choice)
                end,
            },
        },
    }
    -- Window Appearance
    optionsData[#optionsData + 1] = {
        type = "submenu",
        name = SF.GetIconized(RCHAT_APPEARANCEMH, SF.hex.bronze),
        controls = {
            {-- Chat Window Transparency
                type = "slider",
                name = L(RCHAT_WINDOWDARKNESS),
                tooltip = L(RCHAT_WINDOWDARKNESSTT),
                min = 0,
                max = 11,
                step = 1,
                getFunc = function() return db.windowDarkness end,
                setFunc = function(newValue)
                    db.windowDarkness = newValue
                    ChangeChatWindowDarkness(true)
                    CHAT_SYSTEM:Maximize()
                end,
                width = "full",
                default = defaults.windowDarkness,
            },
            {-- LAM Option Prevent Chat Fading
                type = "checkbox",
                name = L(RCHAT_PREVENTCHATTEXTFADING),
                tooltip = L(RCHAT_PREVENTCHATTEXTFADINGTT),
                getFunc = function() return db.alwaysShowChat end,
                setFunc = function(newValue) db.alwaysShowChat = newValue end,
                width = "full",
                default = defaults.alwaysShowChat,
            },
            {-- Augment lines of chat
                type = "checkbox",
                name = L(RCHAT_AUGMENTHISTORYBUFFER),
                tooltip = L(RCHAT_AUGMENTHISTORYBUFFERTT),
                getFunc = function() return db.augmentHistoryBuffer end,
                setFunc = function(newValue) db.augmentHistoryBuffer = newValue end,
                width = "full",
                default = defaults.augmentHistoryBuffer,
            },
            {-- LAM Option Use one color for lines
                type = "checkbox",
                name = L(RCHAT_USEONECOLORFORLINES),
                tooltip = L(RCHAT_USEONECOLORFORLINESTT),
                getFunc = function() return db.oneColour end,
                setFunc = function(newValue) db.oneColour = newValue end,
                width = "full",
                default = defaults.oneColour,
            },
            {-- Minimize at launch
                type = "checkbox",
                name = L(RCHAT_CHATMINIMIZEDATLAUNCH),
                tooltip = L(RCHAT_CHATMINIMIZEDATLAUNCHTT),
                getFunc = function() return db.chatMinimizedAtLaunch end,
                setFunc = function(newValue) db.chatMinimizedAtLaunch = newValue end,
                width = "full",
                default = defaults.chatMinimizedAtLaunch,
            },
            {-- Minimize Menus
                type = "checkbox",
                name = L(RCHAT_CHATMINIMIZEDINMENUS),
                tooltip = L(RCHAT_CHATMINIMIZEDINMENUSTT),
                getFunc = function() return db.chatMinimizedInMenus end,
                setFunc = function(newValue) db.chatMinimizedInMenus = newValue end,
                width = "full",
                default = defaults.chatMinimizedInMenus,
            },
            { -- Maximize After Menus
                type = "checkbox",
                name = L(RCHAT_CHATMAXIMIZEDAFTERMENUS),
                tooltip = L(RCHAT_CHATMAXIMIZEDAFTERMENUSTT),
                getFunc = function() return db.chatMaximizedAfterMenus end,
                setFunc = function(newValue) db.chatMaximizedAfterMenus = newValue end,
                width = "full",
                default = defaults.chatMaximizedAfterMenus,
            },
            { -- Fonts
                type = "dropdown",
                name = L(RCHAT_FONTCHANGE),
                tooltip = L(RCHAT_FONTCHANGETT),
                choices = fontsDefined,
                width = "full",
                getFunc = function() return db.fonts end,
                setFunc = function(choice)
                    db.fonts = choice
                    ChangeChatFont(true)
                    ReloadUI()
                end,
                default = defaults.fontChange,
                warning = "ReloadUI"
            },
            {-- Copy Chat
                type = "checkbox",
                name = L(RCHAT_ENABLECOPY),
                tooltip = L(RCHAT_ENABLECOPYTT),
                getFunc = function() return db.enablecopy end,
                setFunc = function(newValue) db.enablecopy = newValue end,
                width = "full",
                default = defaults.enablecopy,
            },--
        },
    } -- LAM Menu Whispers
    -- Whispers
    optionsData[#optionsData + 1] = {
        type = "submenu",
        name = SF.GetIconized(RCHAT_IMH, SF.hex.bronze),
        controls = {
			{
				type = "checkbox",
				name = GetString(RCHAT_WHISPSOUND_ENABLED),
				getFunc = function() return db.whispsoundEnabled end,
				setFunc = function(value) db.whispsoundEnabled = value end,
				--disabled = function() return not db.whispsoundEnabled end,
				width = "half",
			},
            {-- Whispers: Sound
                type = "slider",
                name = L(RCHAT_SOUNDFORINCWHISPS),
                tooltip = L(RCHAT_SOUNDFORINCWHISPSTT),
                min = 1, max = SF.numSounds(), step = 1,
                getFunc = function()
                    if type(db.soundforincwhisps) == "string" then
                        return SF.getSoundIndex(db.soundforincwhisps)
                    end
                    return SF.getSoundIndex(db.soundforincwhisps)
                end,
                setFunc = function(value)
                    db.soundforincwhisps = SF.getSound(value)
                    local descCtrl = WINDOW_MANAGER:GetControlByName("RCHAT_WHISP_SOUND")
                    if descCtrl ~= nil then
                        descCtrl.data.text = SF.ColorText(db.soundforincwhisps, SF.hex.normal)
                    end
                    SF.PlaySound(db.soundforincwhisps)
                end,
                width = "half",
                default = defaults.soundforincwhisps,
            },
            {
                type = "description",
                title = L(RCHAT_SOUND_NAME),
                reference = "RCHAT_WHISP_SOUND",
                text = SF.ColorText(db.soundforincwhisps, SF.hex.normal),
            },
            {-- -- LAM Option Whisper: Visual Notification
                type = "checkbox",
                name = L(RCHAT_NOTIFYIM),
                tooltip = L(RCHAT_NOTIFYIMTT),
                getFunc = function() return db.notifyIM end,
                setFunc = function(newValue) db.notifyIM = newValue end,
                width = "full",
                default = defaults.notifyIM,
            },
        },
    }
    -- Restore Chat
    optionsData[#optionsData + 1] = {
        type = "submenu",
        name = SF.GetIconized(RCHAT_RESTORECHATH, SF.hex.bronze),
        controls = {
            {-- LAM Option Restore: After ReloadUI
                type = "checkbox",
                name = L(RCHAT_RESTOREONRELOADUI),
                tooltip = L(RCHAT_RESTOREONRELOADUITT),
                getFunc = function() return db.restoreOnReloadUI end,
                setFunc = function(newValue) db.restoreOnReloadUI = newValue end,
                width = "half",
                default = defaults.restoreOnReloadUI,
            },
            {-- LAM Option Restore: Kicked
                type = "checkbox",
                name = L(RCHAT_RESTOREONAFK),
                tooltip = L(RCHAT_RESTOREONAFKTT),
                getFunc = function() return db.restoreOnAFK end,
                setFunc = function(newValue) db.restoreOnAFK = newValue end,
                width = "half",
                default = defaults.restoreOnAFK,
            },
            {-- LAM Option Restore: Logout
                type = "checkbox",
                name = L(RCHAT_RESTOREONLOGOUT),
                tooltip = L(RCHAT_RESTOREONLOGOUTTT),
                getFunc = function() return db.restoreOnLogOut end,
                setFunc = function(newValue) db.restoreOnLogOut = newValue end,
                width = "half",
                default = defaults.restoreOnLogOut,
            },
            {-- LAM Option Restore: Leave
                type = "checkbox",
                name = L(RCHAT_RESTOREONQUIT),
                tooltip = L(RCHAT_RESTOREONQUITTT),
                getFunc = function() return db.restoreOnQuit end,
                setFunc = function(newValue) db.restoreOnQuit = newValue end,
                width = "half",
                default = defaults.restoreOnQuit,
            },
            {-- LAM Option Restore: Hours
                type = "slider",
                name = L(RCHAT_TIMEBEFORERESTORE),
                tooltip = L(RCHAT_TIMEBEFORERESTORETT),
                min = 1,
                max = 24,
                step = 1,
                getFunc = function() return db.timeBeforeRestore end,
                setFunc = function(newValue) db.timeBeforeRestore = newValue end,
                width = "full",
                default = defaults.timeBeforeRestore,
            },
            {-- LAM Option Restore: System Messages
                type = "checkbox",
                name = L(RCHAT_RESTORESYSTEM),
                tooltip = L(RCHAT_RESTORESYSTEMTT),
                getFunc = function() return db.restoreSystem end,
                setFunc = function(newValue) db.restoreSystem = newValue end,
                width = "full",
                default = defaults.restoreSystem,
            },
            {-- LAM Option Restore: System Only Messages
                type = "checkbox",
                name = L(RCHAT_RESTORESYSTEMONLY),
                tooltip = L(RCHAT_RESTORESYSTEMONLYTT),
                getFunc = function() return db.restoreSystemOnly end,
                setFunc = function(newValue) db.restoreSystemOnly = newValue end,
                width = "full",
                default = defaults.restoreSystemOnly,
            },
            {-- LAM Option Restore: Whispers
                type = "checkbox",
                name = L(RCHAT_RESTOREWHISPS),
                tooltip = L(RCHAT_RESTOREWHISPSTT),
                getFunc = function() return db.restoreWhisps end,
                setFunc = function(newValue) db.restoreWhisps = newValue end,
                width = "full",
                default = defaults.restoreWhisps,
            },
            {-- LAM Option Restore: Text entry history
                type = "checkbox",
                name = L(RCHAT_RESTORETEXTENTRYHISTORYATLOGOUTQUIT),
                tooltip = L(RCHAT_RESTORETEXTENTRYHISTORYATLOGOUTQUITTT),
                getFunc = function() return db.restoreTextEntryHistoryAtLogOutQuit end,
                setFunc = function(newValue) db.restoreTextEntryHistoryAtLogOutQuit = newValue end,
                width = "full",
                default = defaults.restoreTextEntryHistoryAtLogOutQuit,
            },
        },
    } -- Anti-Spam   Timestamp options
    -- Anti Spam
    optionsData[#optionsData + 1] = {
        type = "submenu",
        name = SF.GetIconized(RCHAT_ANTISPAMH, SF.hex.bronze),
        controls = {
            {-- flood protect
                type = "checkbox",
                name = L(RCHAT_FLOODPROTECT),
                tooltip = L(RCHAT_FLOODPROTECTTT),
                getFunc = function() return db.floodProtect end,
                setFunc = function(newValue) db.floodProtect = newValue end,
                width = "full",
                default = defaults.floodProtect,
            }, --Anti spam  grace period
            {
                type = "slider",
                name = L(RCHAT_FLOODGRACEPERIOD),
                tooltip = L(RCHAT_FLOODGRACEPERIODTT),
                min = 0,
                max = 180,
                step = 1,
                getFunc = function() return db.floodGracePeriod end,
                setFunc = function(newValue) db.floodGracePeriod = newValue end,
                width = "full",
                default = defaults.floodGracePeriod,
                disabled = function() return not db.floodProtect end,
            },
            {
                type = "checkbox",
                name = L(RCHAT_LOOKINGFORPROTECT),
                tooltip = L(RCHAT_LOOKINGFORPROTECTTT),
                getFunc = function() return db.lookingForProtect end,
                setFunc = function(newValue) db.lookingForProtect = newValue end,
                width = "full",
                default = defaults.lookingForProtect,
            },
            {
            type = "checkbox",
                name = L(RCHAT_WANTTOPROTECT),
                tooltip = L(RCHAT_WANTTOPROTECTTT),
                getFunc = function() return db.wantToProtect end,
                setFunc = function(newValue) db.wantToProtect = newValue end,
                width = "full",
                default = defaults.wantToProtect,
            },
            {
            type = "checkbox",
                name = L(RCHAT_GUILDPROTECT),
                tooltip = L(RCHAT_GUILDPROTECTTT),
                getFunc = function() return db.guildProtect end,
                setFunc = function(newValue) db.guildProtect = newValue end,
                width = "full",
                default = defaults.guildProtect,
            },
            {
                type = "slider",
                name = L(RCHAT_SPAMGRACEPERIOD),
                tooltip = L(RCHAT_SPAMGRACEPERIODTT),
                min = 0,
                max = 10,
                step = 1,
                getFunc = function() return db.spam.spamGracePeriod end,
                setFunc = function(newValue) db.spam.spamGracePeriod = newValue end,
                width = "full",
                default = defaults.spam.spamGracePeriod,
            },
        },
    } -- Timestamp options

    local function isDisabled_NPCColors()
        if db.useESOcolors then
            return true
        else
            return db.allNPCSameColour
        end
    end

    local function isDisabled_ZoneColors()
        if db.useESOcolors then
            return true
        else
            return db.allZonesSameColour
        end
    end

    -- Chat Colors
    optionsData[#optionsData + 1] = {
        type = "submenu",
        name = SF.GetIconized(RCHAT_COLORSH, SF.hex.bronze),
        controls = {
            {-- LAM Option Use ESO Colors
                type = "checkbox",
                name = L(RCHAT_USEESOCOLORS),
                tooltip = L(RCHAT_USEESOCOLORSTT),
                getFunc = function() return db.useESOcolors end,
                setFunc = function(newValue) db.useESOcolors = newValue end,
                width = "half",
                default = defaults.useESOcolors,
            },
            {-- LAM Option Difference Between ESO Colors
                type = "slider",
                name = L(RCHAT_DIFFFORESOCOLORS),
                tooltip = L(RCHAT_DIFFFORESOCOLORSTT),
                min = 0,
                max = 100,
                step = 1,
                getFunc = function() return db.diffforESOcolors end,
                setFunc = function(newValue) db.diffforESOcolors = newValue end,
                width = "half",
                default = defaults.diffforESOcolors,
                disabled = function() return not db.useESOcolors end,
            },
            {
                type = "header",
                name = SF.GetIconized(RCHAT_CHATCOLORSH, SF.hex.superior),
                width = "full",
            },
            {
                type = "description",
                text = RCHAT_CHATCOLORTT,
            },
            {-- Say players left
                type = "colorpicker",
                name = L(RCHAT_SAY),
                tooltip = L(RCHAT_SAYTT),
                width = "half",
                getFunc = function() return getLeftColorRGB(CHAT_CHANNEL_SAY) end,
                setFunc = function(r, g, b) rChat.setLeftColor(CHAT_CHANNEL_SAY, r, g, b) end,
                default = getLeftColorRGB(CHAT_CHANNEL_SAY),
                disabled = function() return db.useESOcolors end,
            },
            {-- Say players right
                type = "colorpicker",
                name = L(RCHAT_SAYCHAT),
                tooltip = L(RCHAT_SAYCHATTT),
                width = "half",
                getFunc = function() return getRightColorRGB(CHAT_CHANNEL_SAY) end,
                setFunc = function(r, g, b) rChat.setRightColor(CHAT_CHANNEL_SAY, r, g, b) end,
                default = getRightColorRGB(CHAT_CHANNEL_SAY),
                disabled = function() return db.useESOcolors end,
            },
            {-- Zone Player left
                type = "colorpicker",
                name = L(RCHAT_ZONE),
                tooltip = L(RCHAT_ZONETT),
                width = "half",
                getFunc = function() return getLeftColorRGB(CHAT_CHANNEL_ZONE) end,
                setFunc = function(r, g, b) rChat.setLeftColor(CHAT_CHANNEL_ZONE, r, g, b) end,
                default = getLeftColorRGB(CHAT_CHANNEL_ZONE),
                disabled = function() return db.useESOcolors end,
            },
            {-- Zone Player right
                type = "colorpicker",
                name = L(RCHAT_ZONECHAT),
                tooltip = L(RCHAT_ZONECHATTT),
                width = "half",
                getFunc = function() return getRightColorRGB(CHAT_CHANNEL_ZONE) end,
                setFunc = function(r, g, b) rChat.setRightColor(CHAT_CHANNEL_ZONE, r, g, b) end,
                default = getRightColorRGB(CHAT_CHANNEL_ZONE),
                disabled = function() return db.useESOcolors end,
            },
            {-- Yell Player left
                type = "colorpicker",
                name = L(RCHAT_YELL),
                tooltip = L(RCHAT_YELLTT),
                width = "half",
                getFunc = function() return getLeftColorRGB(CHAT_CHANNEL_YELL) end,
                setFunc = function(r, g, b) rChat.setLeftColor(CHAT_CHANNEL_YELL, r, g, b) end,
                default = getLeftColorRGB(CHAT_CHANNEL_YELL),
                disabled = function() return db.useESOcolors end,
            },
            {-- Yell Player right
                type = "colorpicker",
                name = L(RCHAT_YELLCHAT),
                tooltip = L(RCHAT_YELLCHATTT),
                width = "half",
                getFunc = function() return getRightColorRGB(CHAT_CHANNEL_YELL) end,
                setFunc = function(r, g, b) rChat.setRightColor(CHAT_CHANNEL_YELL, r, g, b) end,
                default = getRightColorRGB(CHAT_CHANNEL_YELL),
                disabled = function() return db.useESOcolors end,
            },
            {-- Whisper Incoming left
                type = "colorpicker",
                name = L(RCHAT_INCOMINGWHISPERS),
                tooltip = L(RCHAT_INCOMINGWHISPERSTT),
                width = "half",
                getFunc = function() return getLeftColorRGB(CHAT_CHANNEL_WHISPER) end,
                setFunc = function(r, g, b) rChat.setLeftColor(CHAT_CHANNEL_WHISPER, r, g, b) end,
                default = getLeftColorRGB(CHAT_CHANNEL_WHISPER),
                disabled = function() return db.useESOcolors end,
            },
            {-- Whisper Incoming right
                type = "colorpicker",
                name = L(RCHAT_INCOMINGWHISPERSCHAT),
                tooltip = L(RCHAT_INCOMINGWHISPERSCHATTT),
                width = "half",
                getFunc = function() return getRightColorRGB(CHAT_CHANNEL_WHISPER) end,
                setFunc = function(r, g, b) rChat.setRightColor(CHAT_CHANNEL_WHISPER, r, g, b) end,
                default = getRightColorRGB(CHAT_CHANNEL_WHISPER),
                disabled = function() return db.useESOcolors end,
            },
            {-- Whisper Outgoing left
                type = "colorpicker",
                name = L(RCHAT_OUTGOINGWHISPERS),
                tooltip = L(RCHAT_OUTGOINGWHISPERSTT),
                width = "half",
                getFunc = function() return getLeftColorRGB(CHAT_CHANNEL_WHISPER_SENT) end,
                setFunc = function(r, g, b) rChat.setLeftColor(CHAT_CHANNEL_WHISPER_SENT, r, g, b) end,
                default = getLeftColorRGB(CHAT_CHANNEL_WHISPER_SENT),
                disabled = function() return db.useESOcolors end,
            },
            {-- Whisper Outgoing right
                type = "colorpicker",
                name = L(RCHAT_OUTGOINGWHISPERSCHAT),
                tooltip = L(RCHAT_OUTGOINGWHISPERSCHATTT),
                width = "half",
                getFunc = function() return getRightColorRGB(CHAT_CHANNEL_WHISPER_SENT) end,
                setFunc = function(r, g, b) rChat.setRightColor(CHAT_CHANNEL_WHISPER_SENT, r, g, b) end,
                default = getRightColorRGB(CHAT_CHANNEL_WHISPER_SENT),
                disabled = function() return db.useESOcolors end,
            },
            {-- Group left
                type = "colorpicker",
                name = L(RCHAT_GROUP),
                tooltip = L(RCHAT_GROUPTT),
                width = "half",
                getFunc = function() return getLeftColorRGB(CHAT_CHANNEL_PARTY) end,
                setFunc = function(r, g, b) rChat.setLeftColor(CHAT_CHANNEL_PARTY, r, g, b) end,
                default = getLeftColorRGB(CHAT_CHANNEL_PARTY),
                disabled = function() return db.useESOcolors end,
            },
            {-- Group right
                type = "colorpicker",
                name = L(RCHAT_GROURCHAT),
                tooltip = L(RCHAT_GROURCHATTT),
                width = "half",
                getFunc = function() return getRightColorRGB(CHAT_CHANNEL_PARTY) end,
                setFunc = function(r, g, b) rChat.setRightColor(CHAT_CHANNEL_PARTY, r, g, b) end,
                default = getRightColorRGB(CHAT_CHANNEL_PARTY),
                disabled = function() return db.useESOcolors end,
            },
            {
                type = "header",
                name = SF.GetIconized(RCHAT_OTHERCOLORSH, SF.hex.superior),
                width = "full",
            },
            {
                type = "description",
                text = RCHAT_OTHERCOLORTT,
            },
            {-- Emote left
                type = "colorpicker",
                name = L(RCHAT_EMOTES),
                tooltip = L(RCHAT_EMOTESTT),
                width = "half",
                getFunc = function() return getLeftColorRGB(CHAT_CHANNEL_EMOTE) end,
                setFunc = function(r, g, b) rChat.setLeftColor(CHAT_CHANNEL_EMOTE, r, g, b) end,
                default = getLeftColorRGB(CHAT_CHANNEL_EMOTE),
                disabled = function() return db.useESOcolors end,
            },
            {-- Emote right
                type = "colorpicker",
                name = L(RCHAT_EMOTESCHAT),
                tooltip = L(RCHAT_EMOTESCHATTT),
                width = "half",
                getFunc = function() return getRightColorRGB(CHAT_CHANNEL_EMOTE) end,
                setFunc = function(r, g, b) rChat.setRightColor(CHAT_CHANNEL_EMOTE, r, g, b) end,
                default = getRightColorRGB(CHAT_CHANNEL_EMOTE),
                disabled = function() return db.useESOcolors end,
            },
            {
                type = "header",
                name = SF.GetIconized(RCHAT_NPC, SF.hex.superior),
                width = "full",
            },
            {-- NPC Say left
                type = "colorpicker",
                name = L(RCHAT_NPCSAY),
                tooltip = L(RCHAT_NPCSAYTT),
                width = "half",
                getFunc = function() return getLeftColorRGB(CHAT_CHANNEL_MONSTER_SAY) end,
                setFunc = function(r, g, b) rChat.setLeftColor(CHAT_CHANNEL_MONSTER_SAY, r, g, b) end,
                default = getLeftColorRGB(CHAT_CHANNEL_MONSTER_SAY),
                disabled = function() return db.useESOcolors end,
            },
            {-- NPC Say right
                type = "colorpicker",
                name = L(RCHAT_NPCSAYCHAT),
                tooltip = L(RCHAT_NPCSAYCHATTT),
                width = "half",
                getFunc = function() return getRightColorRGB(CHAT_CHANNEL_MONSTER_SAY) end,
                setFunc = function(r, g, b) rChat.setRightColor(CHAT_CHANNEL_MONSTER_SAY, r, g, b) end,
                default = getRightColorRGB(CHAT_CHANNEL_MONSTER_SAY),
                disabled = function() return db.useESOcolors end,
            },
            {-- LAM Option Use same color for all NPC
                type = "checkbox",
                name = L(RCHAT_ALLNPCSAMECOLOUR),
                tooltip = L(RCHAT_ALLNPCSAMECOLOURTT),
                getFunc = function() return db.allNPCSameColour end,
                setFunc = function(newValue) db.allNPCSameColour = newValue end,
                width = "full",
                default = defaults.allNPCSameColour,
            },
            {-- NPC Yell left
                type = "colorpicker",
                name = L(RCHAT_NPCYELL),
                tooltip = L(RCHAT_NPCYELLTT),
                width = "half",
                getFunc = function() return getLeftColorRGB(CHAT_CHANNEL_MONSTER_YELL) end,
                setFunc = function(r, g, b) rChat.setLeftColor(CHAT_CHANNEL_MONSTER_YELL, r, g, b) end,
                default = getRightColorRGB(CHAT_CHANNEL_MONSTER_YELL),
                disabled = isDisabled_NPCColors,
            },
            {-- NPC Yell right
                type = "colorpicker",
                name = L(RCHAT_NPCYELLCHAT),
                tooltip = L(RCHAT_NPCYELLCHATTT),
                width = "half",
                getFunc = function() return getRightColorRGB(CHAT_CHANNEL_MONSTER_YELL) end,
                setFunc = function(r, g, b) rChat.setRightColor(CHAT_CHANNEL_MONSTER_YELL, r, g, b) end,
                default = getRightColorRGB(CHAT_CHANNEL_MONSTER_YELL),
                disabled = isDisabled_NPCColors,
            },
            {-- NPC Whisper left
                type = "colorpicker",
                name = L(RCHAT_NPCWHISPER),
                tooltip = L(RCHAT_NPCWHISPERTT),
                width = "half",
                getFunc = function() return getLeftColorRGB(CHAT_CHANNEL_MONSTER_WHISPER) end,
                setFunc = function(r, g, b) rChat.setLeftColor(CHAT_CHANNEL_MONSTER_WHISPER, r, g, b) end,
                default = getLeftColorRGB(CHAT_CHANNEL_MONSTER_WHISPER),
                disabled = isDisabled_NPCColors,
            },
            {-- NPC Whisper right
                type = "colorpicker",
                name = L(RCHAT_NPCWHISPERCHAT),
                tooltip = L(RCHAT_NPCWHISPERCHATTT),
                width = "half",
                getFunc = function() return getRightColorRGB(CHAT_CHANNEL_MONSTER_WHISPER) end,
                setFunc = function(r, g, b) rChat.setRightColor(CHAT_CHANNEL_MONSTER_WHISPER, r, g, b) end,
                default = getRightColorRGB(CHAT_CHANNEL_MONSTER_WHISPER),
                disabled = isDisabled_NPCColors,
            },
            {-- NPC Emote left
                type = "colorpicker",
                name = L(RCHAT_NPCEMOTES),
                tooltip = L(RCHAT_NPCEMOTESTT),
                width = "half",
                getFunc = function() return getLeftColorRGB(CHAT_CHANNEL_MONSTER_EMOTE) end,
                setFunc = function(r, g, b) rChat.setLeftColor(CHAT_CHANNEL_MONSTER_EMOTE, r, g, b) end,
                default = getLeftColorRGB(CHAT_CHANNEL_MONSTER_EMOTE),
                disabled = isDisabled_NPCColors,
            },
            {-- NPC Emote right
                type = "colorpicker",
                name = L(RCHAT_NPCEMOTESCHAT),
                tooltip = L(RCHAT_NPCEMOTESCHATTT),
                width = "half",
                getFunc = function() return getRightColorRGB(CHAT_CHANNEL_MONSTER_EMOTE) end,
                setFunc = function(r, g, b) rChat.setRightColor(CHAT_CHANNEL_MONSTER_EMOTE, r, g, b) end,
                default = getRightColorRGB(CHAT_CHANNEL_MONSTER_EMOTE),
                disabled = isDisabled_NPCColors,
            },
            {
                type = "header",
                name = SF.GetIconized(RCHAT_LANGZONEH, SF.hex.superior),
                width = "full",
            },
            {-- LAM Option Use same color for all zone chats
                type = "checkbox",
                name = L(RCHAT_ALLZONESSAMECOLOUR),
                tooltip = L(RCHAT_ALLZONESSAMECOLOURTT),
                getFunc = function() return db.allZonesSameColour end,
                setFunc = function(newValue) db.allZonesSameColour = newValue end,
                width = "full",
                default = defaults.allZonesSameColour,
            },
            {-- Zone English left
                type = "colorpicker",
                name = L(RCHAT_ENZONE),
                tooltip = L(RCHAT_ENZONETT),
                width = "half",
                getFunc = function() return getLeftColorRGB(CHAT_CHANNEL_ZONE_LANGUAGE_1) end,
                setFunc = function(r, g, b) rChat.setLeftColor(CHAT_CHANNEL_ZONE_LANGUAGE_1, r, g, b) end,
                default = getLeftColorRGB(CHAT_CHANNEL_ZONE_LANGUAGE_1),
                disabled = isDisabled_ZoneColors,
            },
            {-- Zone English right
                type = "colorpicker",
                name = L(RCHAT_ENZONECHAT),
                tooltip = L(RCHAT_ENZONECHATTT),
                width = "half",
                getFunc = function() return getRightColorRGB(CHAT_CHANNEL_ZONE_LANGUAGE_1) end,
                setFunc = function(r, g, b) rChat.setRightColor(CHAT_CHANNEL_ZONE_LANGUAGE_1, r, g, b) end,
                default = getRightColorRGB(CHAT_CHANNEL_ZONE_LANGUAGE_1),
                disabled = isDisabled_ZoneColors,
            },
            {-- Zone French left
                type = "colorpicker",
                name = L(RCHAT_FRZONE),
                tooltip = L(RCHAT_FRZONETT),
                width = "half",
                getFunc = function() return getLeftColorRGB(CHAT_CHANNEL_ZONE_LANGUAGE_2) end,
                setFunc = function(r, g, b) rChat.setLeftColor(CHAT_CHANNEL_ZONE_LANGUAGE_2, r, g, b) end,
                default = getLeftColorRGB(CHAT_CHANNEL_ZONE_LANGUAGE_2),
                disabled = isDisabled_ZoneColors,
            },
            {-- Zone French right
                type = "colorpicker",
                name = L(RCHAT_FRZONECHAT),
                tooltip = L(RCHAT_FRZONECHATTT),
                width = "half",
                getFunc = function() return getRightColorRGB(CHAT_CHANNEL_ZONE_LANGUAGE_2) end,
                setFunc = function(r, g, b) rChat.setRightColor(CHAT_CHANNEL_ZONE_LANGUAGE_2, r, g, b) end,
                default = getRightColorRGB(CHAT_CHANNEL_ZONE_LANGUAGE_2),
                disabled = isDisabled_ZoneColors,
            },
            {-- Zone German left
                type = "colorpicker",
                name = L(RCHAT_DEZONE),
                tooltip = L(RCHAT_DEZONETT),
                width = "half",
                getFunc = function() return getLeftColorRGB(CHAT_CHANNEL_ZONE_LANGUAGE_3) end,
                setFunc = function(r, g, b) rChat.setLeftColor(CHAT_CHANNEL_ZONE_LANGUAGE_3, r, g, b) end,
                default = getLeftColorRGB(CHAT_CHANNEL_ZONE_LANGUAGE_3),
                disabled = isDisabled_ZoneColors,
            },
            {-- Zone German right
                type = "colorpicker",
                name = L(RCHAT_DEZONECHAT),
                tooltip = L(RCHAT_DEZONECHATTT),
                width = "half",
                getFunc = function() return getRightColorRGB(CHAT_CHANNEL_ZONE_LANGUAGE_3) end,
                setFunc = function(r, g, b) rChat.setRightColor(CHAT_CHANNEL_ZONE_LANGUAGE_3, r, g, b) end,
                default = getRightColorRGB(CHAT_CHANNEL_ZONE_LANGUAGE_3),
                disabled = isDisabled_ZoneColors,
            },
            {-- Zone Japanese left
                type = "colorpicker",
                name = L(RCHAT_JPZONE),
                tooltip = L(RCHAT_JPZONETT),
                width = "half",
                getFunc = function() return getLeftColorRGB(CHAT_CHANNEL_ZONE_LANGUAGE_4) end,
                setFunc = function(r, g, b) rChat.setLeftColor(CHAT_CHANNEL_ZONE_LANGUAGE_4, r, g, b) end,
                default = getLeftColorRGB(CHAT_CHANNEL_ZONE_LANGUAGE_4),
                disabled = isDisabled_ZoneColors,
            },
            {-- Zone Japanese right
                type = "colorpicker",
                name = L(RCHAT_JPZONECHAT),
                tooltip = L(RCHAT_JPZONECHATTT),
                width = "half",
                getFunc = function() return getRightColorRGB(CHAT_CHANNEL_ZONE_LANGUAGE_4) end,
                setFunc = function(r, g, b) rChat.setRightColor(CHAT_CHANNEL_ZONE_LANGUAGE_4, r, g, b) end,
                default = getRightColorRGB(CHAT_CHANNEL_ZONE_LANGUAGE_4),
                disabled = isDisabled_ZoneColors,
            },
        },
    }

-- Guilds

--  Guild Stuff
    local function isDisabled_GuildColors(guild)
        if db.useESOcolors then return true end
        if guild ~= 1 then
            return db.allGuildsSameColour
        end
        return false
    end

--
    local guildOptionsData = {
        type = "submenu",
        name = SF.GetIconized(RCHAT_GUILDOPT, SF.hex.bronze),
        controls = {
            {-- LAM Option Show Guild Numbers
                type = "checkbox",
                name = L(RCHAT_GUILDNUMBERS),
                tooltip = L(RCHAT_GUILDNUMBERSTT),
                getFunc = function() return db.showGuildNumbers end,
                setFunc = function(newValue)
                    db.showGuildNumbers = newValue
                end,
                width = "half",
                default = defaults.showGuildNumbers,
            },
            {-- LAM Option Use Same Color for all Guilds
                type = "checkbox",
                name = L(RCHAT_ALLGUILDSSAMECOLOUR),
                tooltip = L(RCHAT_ALLGUILDSSAMECOLOURTT),
                getFunc = function() return db.allGuildsSameColour end,
                setFunc = function(newValue)
                        db.allGuildsSameColour = newValue
                    end,
                width = "half",
                default = defaults.allGuildsSameColour,
            },
        }
    }

    for guild = 1, GetNumGuilds() do

        -- Guildname
        local guildName, guildId = rChat.SafeGetGuildName(guild)

        -- If recently added to a new guild and never go in menu db.formatguild[guildName] won't exist
        if not (db.formatguild[guildName]) then
            -- 2 is default value
            db.formatguild[guildName] = 2
        end
        guildOptionsData.controls[#guildOptionsData.controls + 1] = {
        type = "submenu",
        name = guildName,
        controls = {
            {
                type = "editbox",
                name = L(RCHAT_NICKNAMEFOR),
                tooltip = L(RCHAT_NICKNAMEFORTT) .. " " .. guildName,
                getFunc = function() return db.guildTags[guildName] end,
                setFunc = function(newValue)
                    db.guildTags[guildName] = newValue
                    UpdateGuildChannelNames()
                end,
                width = "full",
                default = "",
            },
            {
                type = "editbox",
                name = L(RCHAT_OFFICERTAG),
                tooltip = L(RCHAT_OFFICERTAGTT),
                width = "full",
                default = "",
                getFunc = function() return db.officertag[guildName] end,
                setFunc = function(newValue)
                    db.officertag[guildName] = newValue
                    UpdateGuildChannelNames()
                end
            },
            {
                type = "editbox",
                name = L(RCHAT_SWITCHFOR),
                tooltip = L(RCHAT_SWITCHFORTT),
                getFunc = function() return db.switchFor[guildName] end,
                setFunc = function(newValue)
                    db.switchFor[guildName] = newValue
                    UpdateGuildSwitches()
                    ZOS_CreateChannelData()
                end,
                width = "full",
                default = "",
            },
            {
                type = "editbox",
                name = L(RCHAT_OFFICERSWITCHFOR),
                tooltip = L(RCHAT_OFFICERSWITCHFORTT),
                width = "full",
                default = "",
                getFunc = function() return db.officerSwitchFor[guildName] end,
                setFunc = function(newValue)
                    db.officerSwitchFor[guildName] = newValue
                    UpdateGuildSwitches()
                    ZOS_CreateChannelData()
                end
            },
            -- Name Format
            {
                type = "dropdown",
                name = L(RCHAT_NAMEFORMAT),
                tooltip = L(RCHAT_NAMEFORMATTT),
                choices = {L(RCHAT_FORMATCHOICE1), L(RCHAT_FORMATCHOICE2), L(RCHAT_FORMATCHOICE3)},
                getFunc = function()
                    -- Config per guild
                    if db.formatguild[guildName] == 1 then
                        return L(RCHAT_FORMATCHOICE1)
                    elseif db.formatguild[guildName] == 2 then
                        return L(RCHAT_FORMATCHOICE2)
                    elseif db.formatguild[guildName] == 3 then
                        return L(RCHAT_FORMATCHOICE3)
                    else
                        -- When user click on LAM reinit button
                        return L(RCHAT_FORMATCHOICE2)
                    end
                end,
                setFunc = function(choice)
                    if choice == L(RCHAT_FORMATCHOICE1) then
                        db.formatguild[guildName] = 1
                    elseif choice == L(RCHAT_FORMATCHOICE2) then
                        db.formatguild[guildName] = 2
                    elseif choice == L(RCHAT_FORMATCHOICE3) then
                        db.formatguild[guildName] = 3
                    else
                        -- When user click on LAM reinit button
                        db.formatguild[guildName] = 2
                    end
                end,
                width = "full",
                default = defaults.formatguild[0],
            },
            {-- guild left
                type = "colorpicker",
                name = zo_strformat(RCHAT_MEMBERS, guildName),
                tooltip = zo_strformat(RCHAT_SETCOLORSFORTT, guildName),
                getFunc = function() return getLeftColorRGB(GetGuildChannel(guild)) end,
                setFunc = function(r, g, b) rChat.setLeftColor(GetGuildChannel(guild), r, g, b) end,
                default = getLeftColorRGB(GetGuildChannel(guild)),
                disabled = isDisabled_GuildColors(guild),
            },
            {-- guild right
                type = "colorpicker",
                name = zo_strformat(RCHAT_CHAT, guildName),
                tooltip = zo_strformat(RCHAT_SETCOLORSFORCHATTT, guildName),
                getFunc = function() return getRightColorRGB(GetGuildChannel(guild)) end,
                setFunc = function(r, g, b) rChat.setRightColor(GetGuildChannel(guild), r, g, b) end,
                default = getLeftColorRGB(GetGuildChannel(guild)),
                disabled = isDisabled_GuildColors(guild),
            },
            {-- officer left
                type = "colorpicker",
                name = zo_strformat(RCHAT_MEMBERS, guildName..L(RCHAT_OFFICERSTT)),
                tooltip = zo_strformat(RCHAT_SETCOLORSFOROFFICIERSTT, guildName),
                getFunc = function()
                    local _, ofc_channel = GetGuildChannel(guild)
                    return getLeftColorRGB(ofc_channel)
                end,
                setFunc = function(r, g, b)
                    local _, ofc_channel = GetGuildChannel(guild)
                    rChat.setLeftColor(ofc_channel, r, g, b)
                end,
                default = function()
                    local _, ofc_channel = GetGuildChannel(guild)
                    return getLeftColorRGB(ofc_channel)
                end,
                disabled = isDisabled_GuildColors(guild),
            },
            {-- officer right
                type = "colorpicker",
                name = zo_strformat(RCHAT_CHAT, guildName..L(RCHAT_OFFICERSTT)),
                tooltip = zo_strformat(RCHAT_SETCOLORSFOROFFICIERSCHATTT, guildName),
                getFunc = function()
                    local _, ofc_channel = GetGuildChannel(guild)
                    return getRightColorRGB(ofc_channel)
                end,
                setFunc = function(r, g, b)
                    local _, ofc_channel = GetGuildChannel(guild)
                    rChat.setRightColor(ofc_channel, r, g, b)
                end,
                default = function()
                    local _, ofc_channel = GetGuildChannel(guild)
                    return getRightColorRGB(ofc_channel)
                end,
                disabled = isDisabled_GuildColors(guild),
            },
        },
    }
    end


    optionsData[#optionsData + 1] = guildOptionsData


    LAM:RegisterOptionControls("rChatOptions", optionsData)

end

-- Initialises the settings and settings menu
local function BuildLAM()

    local panelData = {
        type = "panel",
        name = rChat.name,
        displayName = rChat.settingDisplayName,
        author = rChat.author,
        version = rChat.version,
        slashCommand = "/rchat",
        registerForRefresh = true,
        registerForDefaults = true,
    }

    rData.LAMPanel = LAM:RegisterAddonPanel("rChatOptions", panelData)

    -- Build OptionTable. In a separate func in order to rebuild it in case of Guild Reorg.
    SyncCharacterSelectChoices()
    BuildLAMPanel()

end
--**Settings End


-- Triggered by EVENT_GUILD_SELF_JOINED_GUILD
local function OnSelfJoinedGuild(_, _, guildName)

    -- It will rebuild optionsTable and recreate tables if user didn't went in this section before
    BuildLAMPanel()

    -- If recently added to a new guild and never go in menu db.formatguild[guildName] won't exist, it won't create the value if joining an known guild
    if not db.formatguild[guildName] then
        -- 2 is default value
        db.formatguild[guildName] = 2
    end

    -- Save Guild indexes for guild reorganization
    SaveGuildIndexes()

end

-- Revert category settings for a guild
local function RevertCategories(guildName)

    local localPlayer = GetUnitName("player")
    -- Old GuildId
    local oldIndex = rData.guildIndexes[guildName]
    -- old Total Guilds
    local totGuilds = GetNumGuilds() + 1

    if oldIndex and oldIndex < totGuilds then

        -- If our guild was not the last one, need to revert colors
        -- Does not need to reset chat settings for first guild if the 2nd has been left, same for 1-2/3 and 1-2-3/4
        for iGuilds=oldIndex, (totGuilds - 1) do

            -- If default channel was g1, keep it g1
            if not (db.defaultchannel == CHAT_CATEGORY_GUILD_1 or db.defaultchannel == CHAT_CATEGORY_OFFICER_1) then

                if db.defaultchannel == (CHAT_CATEGORY_GUILD_1 + iGuilds) then
                    db.defaultchannel = (CHAT_CATEGORY_GUILD_1 + iGuilds - 1)
                elseif db.defaultchannel == (CHAT_CATEGORY_OFFICER_1 + iGuilds) then
                    db.defaultchannel = (CHAT_CATEGORY_OFFICER_1 + iGuilds - 1)
                end

            end

            -- New Guild color for Guild #X is the old #X+1
            local gcolor = db.chatConfSync[localPlayer].colors[CHAT_CATEGORY_GUILD_1 + iGuilds]
            SetChatCategoryColor(CHAT_CATEGORY_GUILD_1 + iGuilds - 1,
                gcolor.red, gcolor.green, gcolor.blue)

            -- New Officer color for Guild #X is the old #X+1
            gcolor = db.chatConfSync[localPlayer].colors[CHAT_CATEGORY_OFFICER_1 + iGuilds]
            SetChatCategoryColor(CHAT_CATEGORY_OFFICER_1 + iGuilds - 1,
                gcolor.red, gcolor.green, gcolor.blue)

            -- Restore tab config previously set.
            local tabs = db.chatConfSync[localPlayer].tabs
            for numTab in ipairs (CHAT_SYSTEM.primaryContainer.windows) do
                if tabs[numTab] then
                    SetChatContainerTabCategoryEnabled(1, numTab, (CHAT_CATEGORY_GUILD_1 + iGuilds - 1),
                        tabs[numTab].enabledCategories[CHAT_CATEGORY_GUILD_1 + iGuilds])
                    SetChatContainerTabCategoryEnabled(1, numTab, (CHAT_CATEGORY_OFFICER_1 + iGuilds - 1),
                        tabs[numTab].enabledCategories[CHAT_CATEGORY_OFFICER_1 + iGuilds])
                end
            end

        end
    end

end

local function RegisterChatEvents()
    local evthdlrs = {
        [EVENT_CHAT_MESSAGE_CHANNEL] = FormatMessage,
        [EVENT_GROUP_TYPE_CHANGED] = OnGroupTypeChanged,
        [EVENT_FRIEND_PLAYER_STATUS_CHANGED] = OnFriendPlayerStatusChanged,
        [EVENT_IGNORE_ADDED] = OnIgnoreAdded,
        [EVENT_IGNORE_REMOVED] = OnIgnoreRemoved,
        [EVENT_GROUP_MEMBER_LEFT] = OnGroupMemberLeftLC
    }

    if CHAT_ROUTER and CHAT_ROUTER.RegisterMessageFormatter then
        for evtId, evthdlr in pairs(evthdlrs) do
            if evtId and evthdlr and type(evthdlr) == "function" then
                CHAT_ROUTER:RegisterMessageFormatter(evtId, evthdlr)
            end
        end
    end
end

-- Registers the formatMessage function with the libChat to handle chat formatting.
local function OnPlayerActivated()

    EVENT_MANAGER:UnregisterForEvent(rChat.name, EVENT_PLAYER_ACTIVATED)

    --ModifyChannelInfo()
    rData.sceneFirst = false
    rData.activeTab = 1

    ZO_PreHook(CHAT_SYSTEM, "ValidateChatChannel", function(self)
            if (db.enableChatTabChannel  == true) and (self.currentChannel ~= CHAT_CHANNEL_WHISPER) then
                local tabIndex = self.primaryContainer.currentBuffer:GetParent().tab.index
                db.chatTabChannel[tabIndex] = db.chatTabChannel[tabIndex] or {}
                db.chatTabChannel[tabIndex].channel = self.currentChannel
                db.chatTabChannel[tabIndex].target  = self.currentTarget
            end
        end)

    ZO_PreHook(CHAT_SYSTEM.primaryContainer, "HandleTabClick", function(self, tab)
            rData.activeTab = tab.index
            if (db.enableChatTabChannel == true) then
                local tabIndex = tab.index
                if db.chatTabChannel[tabIndex] then
                    CHAT_SYSTEM:SetChannel(db.chatTabChannel[tabIndex].channel, db.chatTabChannel[tabIndex].target)
                end
            end
        end)


    SecurePostHook("ZO_ChatSystem_ScrollToBottom", function(ctrl)
        rChat_RemoveIMNotification()
    end)

    -- Visual Notification PreHook
    ZO_PreHook(CHAT_SYSTEM, "Maximize", function(self)
        CHAT_SYSTEM.IMLabelMin:SetHidden(true)
    end)

    -- AntiSpam
    rData.spamLookingForEnabled = true
    rData.spamWantToEnabled = true
    rData.spamGuildRecruitEnabled = true

    -- Show 1000 lines instead of 200 & Change fade delay
    ShowFadedLines()
    -- Get Chat Tab Names stored in chatTabNames {}
    getTabNames()
    -- Rebuild Lam Panel
    BuildLAMPanel()
    --
    CreateNewChatTab_PostHook()

    -- Should we minimize ?
    MinimizeChatAtLaunch()

    -- Message for new chars
    AutoSyncSettingsForNewPlayer()

    -- Chat Config synchronization
    SyncChatConfig(db.chatSyncConfig, "lastChar")
    SaveChatConfig()

    ZOS_CreateChannelData()

    -- Tags next to entry box
    UpdateGuildChannelNames()

    -- Update Switches
    UpdateGuildSwitches()

    -- Set default channel at login
    SetToDefaultChannel()

    -- Save all category colors
    SaveGuildIndexes()

    -- Restore History if needed
    RestoreChatHistory()
    -- Default Tab
    SetDefaultTab(db.defaultTab)
    -- Change Window apparence
    ChangeChatWindowDarkness()

    -- Handle Copy text
    --CopyToTextEntryText()
    LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_CLICKED_EVENT, OnLinkClicked)
    LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_MOUSE_UP_EVENT, OnLinkClicked)

    RegisterChatEvents()

end


-- Runs whenever "me" left a guild (or gets kicked)
local function OnSelfLeftGuild(_, _, guildName)

    -- It will rebuild optionsTable and recreate tables if user didn't go in this section before
    BuildLAMPanel()

    -- Revert category colors & options
    RevertCategories(guildName)

end

local function SwitchToParty(characterName)

    zo_callLater( function(characterName)     -- characterName = avoid ZOS bug
            if not db.enablepartyswitch then return end
            -- Switch to party channel when joining a group
            if GetRawUnitName("player") == characterName then
                -- If "me" join group
                CHAT_SYSTEM:SetChannel(CHAT_CHANNEL_PARTY)

            elseif GetGroupSize() == 2 then
                -- Someone else joined group
                -- If GetGroupSize() == 2 : Means "me" just created a group and "someone" just joining
                CHAT_SYSTEM:SetChannel(CHAT_CHANNEL_PARTY)
            end
        end,
        200
    )

end

-- Triggers when EVENT_GROUP_MEMBER_JOINED
local function OnGroupMemberJoined(_, characterName)
    SwitchToParty(characterName)
end

-- triggers when EVENT_GROUP_MEMBER_LEFT
local function OnGroupMemberLeft(_, characterName, reason, wasMeWhoLeft)

    if db.enablepartyswitch then
        -- Go back to default channel when leaving a group
        if GetGroupSize() <= 1 then
            -- Only if we was on party
            if CHAT_SYSTEM.currentChannel == CHAT_CHANNEL_PARTY and db.defaultchannel ~= RCHAT_CHANNEL_NONE then
                SetToDefaultChannel()
            end
        end
    end

end

-- Save a category color for guild chat, set by ChatSystem at launch + when user change manually
local function SaveChatCategoryColors(category, r, g, b)
    local confsync = db.chatConfSync[GetUnitName("player")]
    if confsync then
        if confsync.colors[category] == nil then
            confsync.colors[category] = {}
        end
        confsync.colors[category] = { red = r, green = g, blue = b }
    end
end

-- PreHook of ZO_ChatSystem_ShowOptions() and ZO_ChatWindow_OpenContextMenu(control.index)
-- always returns true
local function ChatSystemShowOptions(tabIndex)
    local self = CHAT_SYSTEM.primaryContainer
    tabIndex = tabIndex or (self.currentBuffer and self.currentBuffer:GetParent()
                            and self.currentBuffer:GetParent().tab
                            and self.currentBuffer:GetParent().tab.index)
    local window = self.windows[tabIndex]
    if not window then return true end

    ClearMenu()

    if not ZO_Dialogs_IsShowingDialog() then
        AddMenuItem(L(SI_CHAT_CONFIG_CREATE_NEW), function() self.system:CreateNewChatTab(self)
            end)

        if not window.combatLog and (not self:IsPrimary() or tabIndex ~= 1) then
            AddMenuItem(L(SI_CHAT_CONFIG_REMOVE), function()
                self:ShowRemoveTabDialog(tabIndex)
            end)
        end

        AddMenuItem(L(SI_CHAT_CONFIG_OPTIONS), function()
            self:ShowOptions(tabIndex)
        end)
        AddMenuItem(L(RCHAT_CLEARBUFFER), function()
            rData.tabNotBefore[tabIndex] = GetTimeStamp()
            self.windows[tabIndex].buffer:Clear()
            self:SyncScrollToBuffer()
        end)
    end

    if self:IsPrimary() and tabIndex == 1 then
        if self:IsLocked(tabIndex) then
            AddMenuItem(L(SI_CHAT_CONFIG_UNLOCK), function() self:SetLocked(tabIndex, false) end)
        else
            AddMenuItem(L(SI_CHAT_CONFIG_LOCK), function() self:SetLocked(tabIndex, true) end)
        end
    end

    if window.combatLog then
        -- invert value
        local timestampFlag = (not self:AreTimestampsEnabled(tabIndex)) or false
        AddMenuItem(L(SI_CHAT_CONFIG_HIDE_TIMESTAMP), function()
            self:SetTimestampsEnabled(tabIndex, timestampFlag)
        end)
    end

    ShowMenu(window.tab)

    return true

end

-- Transfer values from old saved vars configurations to
-- new saved vars configurations.
local function SVvers(sv)
    local function convertSpamConfig(sv1)

        -- spam.variables already provided by SF.defaultMissing
        -- just transfer values
        if sv1.spamGracePeriod then
            sv1.spam.spamGracePeriod = sv1.spamGracePeriod
            sv1.spamGracePeriod = nil
        end
        if sv1.floodProtect then
            sv1.spam.floodProtect = sv1.floodProtect
            sv1.floodProtect = nil
        end
        if sv1.floodGracePeriod then
            sv1.spam.floodGracePeriod = sv1.floodGracePeriod
            sv1.floodGracePeriod = nil
        end
        if sv1.lookingForProtect then
            sv1.spam.lookingForProtect = sv1.lookingForProtect
            sv1.lookingForProtect = nil
        end
        if sv1.wantToProtect then
            sv1.spam.wantToProtect = sv1.wantToProtect
            sv1.wantToProtect = nil
        end
        if sv1.guildProtect then
            sv1.spam.guildProtect = sv1.guildProtect
            sv1.guildProtect = nil
        end
    end

    convertSpamConfig(sv)   -- v 1.4.2
end

local function clearSV(savedVars)
    for key, value in pairs(savedVars) do
        if key ~= "version" and type(value) ~= "function" then
            savedVars[key] = nil
        end
    end
end

-- loads saved variables for the account, returns the current
-- applicable settings
local function loadSavedVars(savedvar, sv_version, defaults)

    local save = ZO_SavedVars:NewAccountWide(savedvar, sv_version, nil, defaults)
	SF.defaultMissing(save.mention, defmention)
	SF.defaultMissing(save.spam, defspam)

    -- Transfer old saved vars to new
    SVvers(save)

    save.AddonEpoch = rChat.epoch

    return save
end

-- conversion for saved variables from version 2.4.3 to 2.4.4
local function convertSavedColors()
    for k,v  in pairs(coloredChannels) do
        if db.colours[2*v] then
            --d("found db.colors for "..v)
            db.newcolors[v] =  { db.colours[2*v], db.colours[2*v+1] }
        end
        --
        local sav = {}
        sav["groupleader"] = db.colours["groupleader"]
        sav["timestamp"] = db.colours["timestamp"]
        sav["groupleader1"] = db.colours["groupleader1"]
        sav["tabwarning"] = db.colours["tabwarning"]
        db.colours = sav
    end
end

-- Please note that some things are delayed in OnPlayerActivated() because Chat isn't ready when this function triggers
local function OnAddonLoaded(_, addonName)

    --Protect
    if addonName ~= rChat.name then return end

   rChat.checkLibraryVersions()

    -- Unregisters
    EVENT_MANAGER:UnregisterForEvent(rChat.name, EVENT_ADD_ON_LOADED)

    rChat_ZOS.FormatSysMessage = FormatSysMessage
    rChat_ZOS.FormatMessage = FormatMessage
    rChat_ZOS.FindAutomatedMsg = RAM.FindAutomatedMsg
    rChat_ZOS.cachedMessages = rData.cachedMessages
    rChat_ZOS.saveMsg = function(text)
    end

    -- Saved variables
    rChat.save = loadSavedVars(rChat.savedvar, rChat.sv_version, defaults)
    db = rChat.save
    
    -- setup format strings based on saved vars
    if db.disableBrackets then
        chatStrings = chatStrings_nobrackets
    else
        chatStrings = chatStrings_brackets
    end

    convertSavedColors()

    -- init vars for antispam
    rChat.setSpamConfig(db.spam)

    -- init vars/funcs for ZOS rewritten functions
    rChat_ZOS.tabwarning_color = ZO_ColorDef:New(string.sub(db.colours["tabwarning"],3,8))

    --LAM
    BuildLAM()

    local HRS_TO_SEC = 3600
    local maxage = GetTimeStamp() - (db.timeBeforeRestore * HRS_TO_SEC) - 1
    rChatData.initCache(maxage)

    if not db.chatTabChannel then
        db.chatTabChannel = {}
    end

    if not rChat.tabNames then
        rChat.tabNames = {}
    end

    -- Will set Keybind for "switch to next tab" if needed
    SetSwitchToNextBinding()

    -- Will change font if needed
    ChangeChatFont()

    -- Automated messages
    rChat.InitAutomatedMessages()

    -- Resize, must be loaded before CHAT_SYSTEM is set
    CHAT_SYSTEM.maxContainerWidth, CHAT_SYSTEM.maxContainerHeight = GuiRoot:GetDimensions()

    -- Minimize Chat in Menus
    MinimizeChatInMenus()

    BuildNicknames()

    InitializeURLHandling()

    -- PreHook ReloadUI, SetCVar, LogOut & Quit to handle Chat Import/Export
    ZO_PreHook("ReloadUI", function()
        SaveChatHistory(1)
        SaveChatConfig()
    end)

    ZO_PreHook("SetCVar", function()
        SaveChatHistory(1)
        SaveChatConfig()
    end)

    ZO_PreHook("Logout", function()
        SaveChatHistory(2)
        SaveChatConfig()
    end)

    ZO_PreHook("Quit", function()
        SaveChatHistory(3)
        SaveChatConfig()
    end)

    -- Social option change color
    ZO_PreHook("SetChatCategoryColor", SaveChatCategoryColors)

    -- Chat option change categories filters, add a callLater because settings are set after this function triggers.
    ZO_PreHook("ZO_ChatOptions_ToggleChannel", function() zo_callLater(SaveTabsCategories, 100) end)

    -- Right click on a tab name
    ZO_PreHook("ZO_ChatSystem_ShowOptions", function(control) return ChatSystemShowOptions() end)
    ZO_PreHook("ZO_ChatWindow_OpenContextMenu", function(control) return ChatSystemShowOptions(control.index) end)
    -- Bindings
    ZO_CreateStringId("SI_BINDING_NAME_RCHAT_TOGGLE_CHAT_WINDOW", L(RCHAT_TOGGLECHATBINDING))
    ZO_CreateStringId("SI_BINDING_NAME_RCHAT_WHISPER_MY_TARGET", L(RCHAT_WHISPMYTARGETBINDING))
    ZO_CreateStringId("SI_BINDING_NAME_TAB_1", L(RCHAT_Tab1))
    ZO_CreateStringId("SI_BINDING_NAME_TAB_2", L(RCHAT_Tab2))
    ZO_CreateStringId("SI_BINDING_NAME_TAB_3", L(RCHAT_Tab3))
    ZO_CreateStringId("SI_BINDING_NAME_TAB_4", L(RCHAT_Tab4))
    ZO_CreateStringId("SI_BINDING_NAME_TAB_5", L(RCHAT_Tab5))
    ZO_CreateStringId("SI_BINDING_NAME_TAB_6", L(RCHAT_Tab6))
    ZO_CreateStringId("SI_BINDING_NAME_TAB_7", L(RCHAT_Tab7))
    ZO_CreateStringId("SI_BINDING_NAME_TAB_8", L(RCHAT_Tab8))
    ZO_CreateStringId("SI_BINDING_NAME_TAB_9", L(RCHAT_Tab9))
    ZO_CreateStringId("SI_BINDING_NAME_TAB_10", L(RCHAT_Tab10))
    ZO_CreateStringId("SI_BINDING_NAME_TAB_11", L(RCHAT_Tab11))
    ZO_CreateStringId("SI_BINDING_NAME_TAB_12", L(RCHAT_Tab12))
    -- Register OnSelfJoinedGuild with EVENT_GUILD_SELF_JOINED_GUILD
    EVENT_MANAGER:RegisterForEvent(rChat.name, EVENT_GUILD_SELF_JOINED_GUILD, OnSelfJoinedGuild)

    -- Register OnSelfLeftGuild with EVENT_GUILD_SELF_LEFT_GUILD
    EVENT_MANAGER:RegisterForEvent(rChat.name, EVENT_GUILD_SELF_LEFT_GUILD, OnSelfLeftGuild)

    -- Because ChatSystem is loaded after EVENT_ADDON_LOADED triggers, we use 1st EVENT_PLAYER_ACTIVATED wich is run bit after
    EVENT_MANAGER:RegisterForEvent(rChat.name, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)

    -- Whisp my target
    EVENT_MANAGER:RegisterForEvent(rChat.name, EVENT_RETICLE_TARGET_CHANGED, OnReticleTargetChanged)

    -- Party switches
    EVENT_MANAGER:RegisterForEvent(rChat.name, EVENT_GROUP_MEMBER_JOINED, OnGroupMemberJoined)
    EVENT_MANAGER:RegisterForEvent(rChat.name, EVENT_GROUP_MEMBER_LEFT, OnGroupMemberLeft)

    isAddonLoaded = true

end

--Handled by keybind
function rChat.ToggleChat()

    if CHAT_SYSTEM:IsMinimized() then
        CHAT_SYSTEM:Maximize()
    else
        CHAT_SYSTEM:Minimize()
    end

end

-- Called by bindings
function rChat.WhispMyTarget()
    if targetToWhisp then
        CHAT_SYSTEM:StartTextEntry(nil, CHAT_CHANNEL_WHISPER, targetToWhisp)
    end
end

-- For compatibility. Called by others addons.
function rChat.formatSysMessage(statusMessage)
    return FormatSysMessage(statusMessage)
end

-- For compatibility. Called by others addons.
function rChat_FormatSysMessage(statusMessage)
    return FormatSysMessage(statusMessage)
end

-- For compatibility. Called by others addons.
function rChat_GetChannelColors(channel, from)
    return GetChannelColors(channel, from)
end

--EVENT_MANAGER:RegisterForEvent("rChatData", EVENT_ADD_ON_LOADED, OnDataLoaded)
EVENT_MANAGER:RegisterForEvent(rChat.name, EVENT_ADD_ON_LOADED, OnAddonLoaded)
