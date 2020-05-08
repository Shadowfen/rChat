local L = GetString


local logger = LibDebugLogger("rChat")
logger:SetEnabled(true)
-- contains insertion functions and data references to allow rChat to
-- affect the operation of the revised core ZOS functions below.
rChat_ZOS = {
    FormatSysMessage = function() end,     -- function
    FormatMessage = function() end,     -- function
    FindAutomatedMsg = function(txt) end,
    cachedMessages = {},        -- table of messages for chat restoring
    messagesWereRestored = false, -- bool  (was messagesHaveBeenRestorated)
    tabwarning_color = ZO_ColorDef:New("76BCC3"), -- tab Warning ~ "Azure" (ZOS default),
    saveMsg = function(...)
        logger:Debug(...)
    end,
    disableDebugLoggerBlocking = true,
}

--
function CHAT_ROUTER.AddSystemMessage(self,messageText)
    if not IsChatSystemAvailableForCurrentPlatform() then
        table.insert(rChat_ZOS.cachedMessages, messageText)
        return
    end

    self:FireCallbacks("FormattedChatMessage", messageText, CHAT_CATEGORY_SYSTEM)
end

function CHAT_ROUTER.AddDebugMessage(self,messageText)
    self:AddSystemMessage(messageText)
end

-- Rewrite of core function to save messages if chat system not yet up
-- (from addoncompatibility.lua)
function KEYBOARD_CHAT_SYSTEM:AddMessage(text)

    if LibDebugLogger then
        if rChat_ZOS.disableDebugLoggerBlocking then
            if LibDebugLogger:IsBlockChatOutputEnabled() then
                LibDebugLogger:SetBlockChatOutputEnabled(false)
            end
        else
            if not LibDebugLogger:IsBlockChatOutputEnabled() then
                LibDebugLogger:SetBlockChatOutputEnabled(true)
            end
        end
    end
    
	if CHAT_SYSTEM.primaryContainer and rChat_ZOS.messagesWereRestored then
        for k in ipairs(CHAT_SYSTEM.containers) do
			local chatContainer = CHAT_SYSTEM.containers[k]
            chatContainer:AddEventMessageToContainer(rChat_ZOS.FormatSysMessage(text), CHAT_CATEGORY_SYSTEM)
		end
	else
		table.insert(rChat_ZOS.cachedMessages, text)
	end
end
--
--

-- Rewrite of core local adding restoration of messages from cache
local function EmitMessage(text)
    if CHAT_ROUTER and rChat_ZOS.messagesWereRestored then
        if text == "" then
            text = "[Empty String]"
        end
        CHAT_ROUTER:AddSystemMessage(text)
        --CHAT_ROUTER:AddDebugMessage(text)
    else
        table.insert(rChat_ZOS.cachedMessages, text)
    end
end

-- Copy of core local (no changes from debugutils.lua)
local function EmitTable(t, indent, tableHistory)
    indent        = indent or "."
    tableHistory    = tableHistory or {}

    for k, v in pairs(t)
    do
        local vType = type(v)

        EmitMessage(indent.."("..vType.."): "..tostring(k).." = "..tostring(v))

        if(vType == "table")
        then
            if(tableHistory[v])
            then
                EmitMessage(indent.."Avoiding cycle on table...")
            else
                tableHistory[v] = true
                EmitTable(v, indent.."  ", tableHistory)
            end
        end
    end
end
--
--
-- Copy of a core function (from debugutils.lua)
--   The local EmitMessage() function was rewritten
--   to handle the case of when the chat system is
--   not up.
--   The core df() is still implemented in terms of d() so
--   it is also changed by this.
function d(...)
    for i = 1, select("#", ...) do
        local value = select(i, ...)
        if(type(value) == "table")
        then
            EmitTable(value)
        else
            EmitMessage(tostring (value))
        end
    end
end
--]]
--

-- from libraries\utility\zo_tabbuttongroup.lua
-- Rewrite of core function to use saved var color instead of parameter
function ZO_TabButton_Text_SetTextColor(self, color)
    if self.allowLabelColorChanges then
        local label = GetControl(self, "Text")
        if rChat_ZOS.tabwarning_color then
            label:SetColor(rChat_ZOS.tabwarning_color:UnpackRGBA())
        else
            label:SetColor(color:UnpackRGBA())
        end
    end
    if(self.allowLabelColorChanges) then
	    local label = GetControl(self, "Text")
        label:SetColor(color:UnpackRGBA())
    end
end

--
--

-- from ingame\chatsystem\chatoptions.lua
-- Copy of a core data (nothing changed)
local FILTERS_PER_ROW = 2

-- from ingame\chatsystem\chatoptions.lua
-- Copy of a core data (nothing changed)
-- defines the ordering of the filter categories
local CHANNEL_ORDERING_WEIGHT = {
    [CHAT_CATEGORY_SAY] = 10,
    [CHAT_CATEGORY_YELL] = 20,

    [CHAT_CATEGORY_WHISPER_INCOMING] = 30,
    [CHAT_CATEGORY_PARTY] = 40,

    [CHAT_CATEGORY_EMOTE] = 50,
    [CHAT_CATEGORY_MONSTER_SAY] = 60,

    [CHAT_CATEGORY_ZONE] = 80,
    [CHAT_CATEGORY_ZONE_ENGLISH] = 90,

    [CHAT_CATEGORY_ZONE_FRENCH] = 100,
    [CHAT_CATEGORY_ZONE_GERMAN] = 110,
    -- new values
    [CHAT_CATEGORY_ZONE_JAPANESE] = 120,

    [CHAT_CATEGORY_SYSTEM] = 200,
}

-- Copy of a core function (from chatoptions.lua)
local function FilterComparator(left, right)
    local leftPrimaryCategory = left.channels[1]
    local rightPrimaryCategory = right.channels[1]

    local leftWeight = CHANNEL_ORDERING_WEIGHT[leftPrimaryCategory]
    local rightWeight = CHANNEL_ORDERING_WEIGHT[rightPrimaryCategory]

    if leftWeight and rightWeight then
        return leftWeight < rightWeight
    elseif not leftWeight and not rightWeight then
        return false
    elseif leftWeight then
        return true
    end

    return false
end

-- from ingame\chatsystem\chatoptions.lua
-- Copy of a core data
-- (CHAT_CATEGORY_SYSTEM is commented out from ZOS defaults so we can unselect
-- system messages in a chat tab)
local SKIP_CHANNELS = {
    -- [CHAT_CATEGORY_SYSTEM] = true,
    [CHAT_CATEGORY_GUILD_1] = true,
    [CHAT_CATEGORY_GUILD_2] = true,
    [CHAT_CATEGORY_GUILD_3] = true,
    [CHAT_CATEGORY_GUILD_4] = true,
    [CHAT_CATEGORY_GUILD_5] = true,
    [CHAT_CATEGORY_OFFICER_1] = true,
    [CHAT_CATEGORY_OFFICER_2] = true,
    [CHAT_CATEGORY_OFFICER_3] = true,
    [CHAT_CATEGORY_OFFICER_4] = true,
    [CHAT_CATEGORY_OFFICER_5] = true,
}

local FILTER_PAD_X = 90
local FILTER_PAD_Y = 0
local FILTER_WIDTH = 150
local FILTER_HEIGHT = 27
local INITIAL_XOFFS = 0
local INITIAL_YOFFS = 0

-- from ingame\chatsystem\chatoptions.lua
-- Copy of a core data
-- (Nothing is changed)
--defines channels to be combined under one button
local COMBINED_CHANNELS = {
    [CHAT_CATEGORY_WHISPER_INCOMING] = {parentChannel = CHAT_CATEGORY_WHISPER_INCOMING, name = SI_CHAT_CHANNEL_NAME_WHISPER},
    [CHAT_CATEGORY_WHISPER_OUTGOING] = {parentChannel = CHAT_CATEGORY_WHISPER_INCOMING, name = SI_CHAT_CHANNEL_NAME_WHISPER},

    [CHAT_CATEGORY_MONSTER_SAY] = {parentChannel = CHAT_CATEGORY_MONSTER_SAY, name = SI_CHAT_CHANNEL_NAME_NPC},
    [CHAT_CATEGORY_MONSTER_YELL] = {parentChannel = CHAT_CATEGORY_MONSTER_SAY, name = SI_CHAT_CHANNEL_NAME_NPC},
    [CHAT_CATEGORY_MONSTER_WHISPER] = {parentChannel = CHAT_CATEGORY_MONSTER_SAY, name = SI_CHAT_CHANNEL_NAME_NPC},
    [CHAT_CATEGORY_MONSTER_EMOTE] = {parentChannel = CHAT_CATEGORY_MONSTER_SAY, name = SI_CHAT_CHANNEL_NAME_NPC},
}
--
-- Override of a core function. Nothing is changed except in SKIP_CHANNELS set as above
--  (Allows us to be able to set if we want to filter system messages.)
function CHAT_OPTIONS:InitializeFilterButtons(dialogControl)
    --generate a table of entry data from the chat category header information
    local entryData = {}
    local lastEntry = CHAT_CATEGORY_HEADER_COMBAT - 1

    for i = CHAT_CATEGORY_HEADER_CHANNELS, lastEntry do
        if(SKIP_CHANNELS[i] == nil and GetString("SI_CHATCHANNELCATEGORIES", i) ~= "") then

            if(COMBINED_CHANNELS[i] == nil) then
                entryData[i] = {
                    channels = { i },
                    name = GetString("SI_CHATCHANNELCATEGORIES", i),
                }
            else
                --create the entry for those with combined channels just once
                local parentChannel = COMBINED_CHANNELS[i].parentChannel

                if(not entryData[parentChannel]) then
                    entryData[parentChannel] = {
                        channels = { },
                        name = GetString(COMBINED_CHANNELS[i].name),
                    }
                end

                table.insert(entryData[parentChannel].channels, i)
            end
        end
    end

    --now generate and anchor buttons
    local filterAnchor = ZO_Anchor:New(TOPLEFT, self.filterSection, TOPLEFT, 0, 0)
    local count = 0

    local sortedEntries = {}
    for _, entry in pairs(entryData) do
        sortedEntries[#sortedEntries + 1] = entry
    end

    table.sort(sortedEntries, FilterComparator)

    for _, entry in ipairs(sortedEntries) do
        local filter, key = self.filterPool:AcquireObject()
        filter.key = key

        local button = filter:GetNamedChild("Check")
        ZO_CheckButton_SetLabelText(button, entry.name)
        button.channels = entry.channels
        table.insert(self.filterButtons, button)

        ZO_Anchor_BoxLayout(filterAnchor, filter, count, FILTERS_PER_ROW, FILTER_PAD_X, FILTER_PAD_Y, FILTER_WIDTH, FILTER_HEIGHT, INITIAL_XOFFS, INITIAL_YOFFS)
        count = count + 1
    end
end


-- from ingame\chatsystem\sharedchatsystem.lua
-- Rewrite of a core function
--  Insert processing for automated messages
function KEYBOARD_CHAT_SYSTEM.textEntry:GetText()
    local text = self.editControl:GetText() -- the original total content of this func

    --  Insert processing for automated messages below
    -- make sure we have something to work with
    if not text then return text end

    local st,en,nm = string.find(text,"%s*(!%a+)")
    if not st then return text end
    if string.len(nm) > 12 then return text end

    -- replace automated message indicator with message
    local v, k = rChat_ZOS.FindAutomatedMsg(nm)
    if not v then return text end   -- no such indicator

    text = v.message
    -- replace the automsg indicator with message
    local strln = string.len(v.message)
    if strln > 0 and strln < 352 then
        text = v.message
    end

    -- this is required to properly display the replaced message in chat
    KEYBOARD_CHAT_SYSTEM:OnTextEntryChanged(text)    -- in sharedchatsystem.lua

    -- adjustments required by automated messages
    self.ignoreTextEntryChangedEvent = true
    local spaceStart, spaceEnd = zo_strfind(text, " ", 1, true)
    if spaceStart and spaceStart > 1 then
        text = zo_strsub(text, spaceStart + 1)
        local oldCursorPos = KEYBOARD_CHAT_SYSTEM.textEntry:GetCursorPosition()

        spaceStart = spaceStartOverride or spaceStart
    end
    self.ignoreTextEntryChangedEvent = false
    return text
end

-- recreated from 5.2 ingame\chatsystem\sharedchatsystem.lua
-- initialization was moved to ingame\chatsystem\chatdata.lua, but
-- is no longer callable.
--
-- we need this function to rebuild the switchLookup after we make
-- modifications to guild switch settings
--
-- Build switch lookup table
-- A switch is a string, eg "/zone", which you can start your chat message with to make sure it goes to a specific channel.
-- This lookup table has two kinds of entries in it:
-- * switch string -> channel data.
--     This is used to pick a channel based on the player's message and switch string.
-- * channel ID -> switch string.
--     This is used to enumerate what kinds of channels are available and what switch string you can use to refer to them.
--     Each channel can have multiple switches, in which case only the first switch string is used.
--
function ZOS_CreateChannelData()
    local g_switchLookup = {}
    local channelInfo = ZO_ChatSystem_GetChannelInfo()
    --
    for channelId, data in pairs(channelInfo) do
        data.id = channelId

        if data.switches then
            for switchArg in data.switches:gmatch("%S+") do
                switchArg = switchArg:lower()
                g_switchLookup[switchArg] = data
                if not g_switchLookup[channelId] then
                    g_switchLookup[channelId] = switchArg
                end
            end
        end

        if data.targetSwitches then
            local targetData = ZO_ShallowTableCopy(data)
            targetData.target = channelId
            for switchArg in data.targetSwitches:gmatch("%S+") do
                switchArg = switchArg:lower()
                g_switchLookup[switchArg] = targetData
                if not g_switchLookup[channelId] then
                    g_switchLookup[channelId] = switchArg
                end
            end
        end
    end
    CHAT_SYSTEM.switchLookup = g_switchLookup
    --
end
