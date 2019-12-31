-- contains insertion functions and data references to allow rChat to 
-- affect the operation of the revised core ZOS functions below.
rChat_ZOS = {
    FormatSysMessage = function() end,     -- function
    cachedMessages = {},        -- table of messages for chat restoring
    messagesWereRestored = false, -- bool  (was messagesHaveBeenRestorated)
    tabwarning_color = ZO_ColorDef:New("76BCC3"), -- tab Warning ~ "Azure" (ZOS default),
}


-- Rewrite of core function
function CHAT_SYSTEM:AddMessage(text)

    -- Overwrite CHAT_SYSTEM:AddMessage() function to format it
    -- Overwrite SharedChatContainer:AddDebugMessage(formattedEventText) in order to display system message in specific tabs
    -- CHAT_SYSTEM:Zo_AddMessage() can be used in order to use old function
    -- Store the message in rChat_ZOS.cachedMessages if this one is sent before CHAT_SYSTEM.primaryContainer goes up (before 1st EVENT_PLAYER_ACTIVATED)

    if CHAT_SYSTEM.primaryContainer and rChat_ZOS.messagesWereRestored then
        for k in ipairs(CHAT_SYSTEM.containers) do
            CHAT_SYSTEM.containers[k]:OnChatEvent(nil, rChat_ZOS.FormatSysMessage(text), CHAT_CATEGORY_SYSTEM)
        end
    else
        table.insert(rChat_ZOS.cachedMessages, text)
    end

end

-- Rewrite of core local
-- (adding restoration of messages)
local function EmitMessage(text)
    if CHAT_SYSTEM and CHAT_SYSTEM.primaryContainer and rChat_ZOS.messagesWereRestored then
        if text == "" then
            text = "[Empty String]"
        end
        CHAT_SYSTEM:AddMessage(text)
    else
        table.insert(rChat_ZOS.cachedMessages, text)
    end
end

-- Redefinition of core local
-- (no changes from original)
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


-- Rewrite of a core function
-- (use local EmitTable and EmitMessage)
function d(...)
    for i = 1, select("#", ...) do
        local value = select(i, ...)
        if(type(value) == "table")
        then
            EmitTable(value)
        else
            if CHAT_SYSTEM and CHAT_SYSTEM.primaryContainer and rChat_ZOS.messagesWereRestored then
                EmitMessage(tostring (value))
            else
                table.insert(rChat_ZOS.cachedMessages, text)
            end

        end
    end
end


-- Rewrite of core function to use saved var color instead of parameter
function ZO_TabButton_Text_SetTextColor(self, color)

    if(self.allowLabelColorChanges) then
        local label = GetControl(self, "Text")
        local r, g, b = rChat_ZOS.tabwarning_color:UnpackRGB()
        label:SetColor(r, g, b, 1)
    end
end

-- Copy of core function from chatdata.lua
local function GetOfficerChannelErrorFunction(guildIndex)
    return function()
        if(GetNumGuilds() < guildIndex) then
            return zo_strformat(SI_CANT_GUILD_CHAT_NOT_IN_GUILD, guildIndex)
        else
            return zo_strformat(SI_CANT_OFFICER_CHAT_NO_PERMISSION, GetGuildName(guildIndex))
        end
    end
end

-- Copy of core function from chatdata.lua
local function GetGuildChannelErrorFunction(guildIndex)
    return function()
        if(GetNumGuilds() < guildIndex) then
            return zo_strformat(SI_CANT_GUILD_CHAT_NOT_IN_GUILD, guildIndex)
        else
            return zo_strformat(SI_CANT_GUILD_CHAT_NO_PERMISSION, GetGuildName(guildIndex))
        end
    end
end

-- Copy of a core data (nothing changed)
local FILTERS_PER_ROW = 2

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

    [CHAT_CATEGORY_ZONE_JAPANESE] = 120,
    [CHAT_CATEGORY_SYSTEM] = 130,
}

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

-- Copy of a core data
-- (CHAT_CATEGORY_SYSTEM is commented out)
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

-- Rewrite of a core data
-- (Nothing is changed)
local COMBINED_CHANNELS = {
    [CHAT_CATEGORY_WHISPER_INCOMING] = {parentChannel = CHAT_CATEGORY_WHISPER_INCOMING, name = SI_CHAT_CHANNEL_NAME_WHISPER},
    [CHAT_CATEGORY_WHISPER_OUTGOING] = {parentChannel = CHAT_CATEGORY_WHISPER_INCOMING, name = SI_CHAT_CHANNEL_NAME_WHISPER},

    [CHAT_CATEGORY_MONSTER_SAY] = {parentChannel = CHAT_CATEGORY_MONSTER_SAY, name = SI_CHAT_CHANNEL_NAME_NPC},
    [CHAT_CATEGORY_MONSTER_YELL] = {parentChannel = CHAT_CATEGORY_MONSTER_SAY, name = SI_CHAT_CHANNEL_NAME_NPC},
    [CHAT_CATEGORY_MONSTER_WHISPER] = {parentChannel = CHAT_CATEGORY_MONSTER_SAY, name = SI_CHAT_CHANNEL_NAME_NPC},
    [CHAT_CATEGORY_MONSTER_EMOTE] = {parentChannel = CHAT_CATEGORY_MONSTER_SAY, name = SI_CHAT_CHANNEL_NAME_NPC},
}

-- Rewrite of a core function. Nothing is changed except in SKIP_CHANNELS set as above
function CHAT_OPTIONS:InitializeFilterButtons(dialogControl)
    --generate a table of entry data from the chat category header information
    local entryData = {}
    local lastEntry = CHAT_CATEGORY_HEADER_COMBAT - 1

    for i = CHAT_CATEGORY_HEADER_CHANNELS, lastEntry do
        if(SKIP_CHANNELS[i] == nil and L("SI_CHATCHANNELCATEGORIES", i) ~= "") then

            if(COMBINED_CHANNELS[i] == nil) then
                entryData[i] =
                {
                    channels = { i },
                    name = L("SI_CHATCHANNELCATEGORIES", i),
                }
            else
                --create the entry for those with combined channels just once
                local parentChannel = COMBINED_CHANNELS[i].parentChannel

                if(not entryData[parentChannel]) then
                    entryData[parentChannel] =
                    {
                        channels = { },
                        name = L(COMBINED_CHANNELS[i].name),
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
        button.channels = entry.channels
        table.insert(self.filterButtons, button)

        local label = filter:GetNamedChild("Label")
        label:SetText(entry.name)

        ZO_Anchor_BoxLayout(filterAnchor, filter, count, FILTERS_PER_ROW, FILTER_PAD_X, FILTER_PAD_Y, FILTER_WIDTH, FILTER_HEIGHT, INITIAL_XOFFS, INITIAL_YOFFS)
        count = count + 1
    end
end
