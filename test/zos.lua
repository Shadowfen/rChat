local internal = {
  atname = "@Shadowfen",
  toon = "Shade Windwalker",
  
  guilds = {
  -- id  = {guildname, num_members, guildmaster}
    [1] = {"Ghost Sea Trading", 490, "@epona",}, 
    [2] = {"Eight Shadows of Murder", 25, "@hachh",}, 
    [3] = {"Women of Ebonheart", 90, "@br",}, 
    [4] = {"Dreadlords", 500, "@hades",}, 
    [5] = {"House Mazkein", 480, "@e", },
  }
}

--------------------------------------------------

ZOS ={}

_G["d"] = print

-- localization functions
EsoStrings = {}
EsoStringVersions = {}
ZOS.nextCustomId = 1

function ZO_CreateStringId(stringId, stringToAdd)
    _G[stringId] = ZOS.nextCustomId
    EsoStrings[ZOS.nextCustomId] = stringToAdd
    ZOS.nextCustomId = ZOS.nextCustomId + 1
end

function SafeAddVersion(stringId, stringVersion)
    if(stringId) then
        EsoStringVersions[stringId] = stringVersion
    end
end

function SafeAddString(stringId, stringValue, stringVersion)
    if(stringId) then
        local existingVersion = EsoStringVersions[stringId]
        if((existingVersion == nil) or (existingVersion <= stringVersion)) then
            EsoStrings[stringId] = stringValue
        end
    end
end

function GetString(id)
    return EsoStrings[id]
end
-- end localization functions

function GetTimeStamp()
    return os.time()
end

function GetDisplayName()
  return internal.atname
end


function ZO_DeepTableCopy(source, dest)
    dest = dest or {}
 
    for k, v in pairs(source) do
        if type(v) == "table" then
            dest[k] = ZO_DeepTableCopy(v)
        else
            dest[k] = v
        end
    end
 
    return dest
end

ZO_SavedVars = {}
function ZO_SavedVars:NewAccountWide(vn, ver, nmsp, df)
    local acct = GetDisplayName()
    local tbl = _G[vn].Default[acct]["$AccountWide"]
    if( ver ~= tbl.version ) then
        ZO_DeepTableCopy(df,tbl)
    end
    return tbl
end

function ZO_SavedVars:New(vn, ver, nmsp, df)
    local acct = GetDisplayName()
    local toon = internal.toon
    local tbl = _G[vn].Default[acct][toon]
    if( ver ~= tbl.version ) then
        ZO_DeepTableCopy(df,tbl)
    end
    return tbl
end

function zo_plainstrfind(text, pat)
  return string.find(text, pat)
end

-- guild functions
function GetGuildName(id)
    return internal.guilds[id][1]
end

-- returns number of members, number online, guildmaster
function GetGuildInfo(guildId)
    return internal.guilds[guildId][2], guildId, internal.guilds[guildId][3]
end

function GetGuildId(ndx)
    return ndx
end

-- utilities
function ZO_ClearTable(t)
    for k in pairs(t) do
        t[k] = nil
    end
end

function ZO_ShallowTableCopy(source, dest)
    dest = dest or {}
    
    for k, v in pairs(source) do
        dest[k] = v
    end
    
    return dest
end

function ZO_DeepTableCopy(source, dest)
    dest = dest or {}
     setmetatable (dest, getmetatable(source))
    
    for k, v in pairs(source) do
        if type(v) == "table" then
            dest[k] = ZO_DeepTableCopy(v)
        else
            dest[k] = v
        end
    end
    
    return dest
end

function zo_strformat( fmt, ... )
    print(fmt, ...)
end

function zo_loadstring(...)
    return loadstring(...)
end

function GetCVar(var)
    if var == "language.2" then
        return "en"
    end
    return nil
end

EVENT_MANAGER = {}
function EVENT_MANAGER:UnregisterForEvent()
end
function EVENT_MANAGER:RegisterForEvent()
end

ZO_Object = {}

function ZO_Object:New(template)
    template = template or self
    local newObject = setmetatable ({}, template)
    local mt = getmetatable (newObject)
    mt.__index = template
    
    return newObject
end

function ZO_Object:Subclass()
    return setmetatable({}, {__index = self})
end

function zo_strjoin(separator, ...)
    return table.concat({...}, separator)
end

function ZO_LinkHandler_CreateLinkWithFormat(text, color, linkType, linkStyle, stringFormat, ...)
    --where ... is the data to encode
    if linkType then
        return (stringFormat):format(linkStyle, zo_strjoin(':', linkType, ...), text)
    end
end

LINK_STYLE_BRACKETS = 1
LINK_STYLE_DEFAULT = 0
function ZO_LinkHandler_CreateLink(text, color, linkType, ...) --where ... is the data to encode
    return ZO_LinkHandler_CreateLinkWithFormat(text, color, linkType, LINK_STYLE_BRACKETS, "|H%d:%s|h[%s]|h", ...)
end

function ZO_LinkHandler_CreateLinkWithoutBrackets(text, color, linkType, ...) --where ... is the data to encode
    return ZO_LinkHandler_CreateLinkWithFormat(text, color, linkType, LINK_STYLE_DEFAULT, "|H%d:%s|h%s|h", ...)
end

function IsDecoratedDisplayName(name)
    if string.sub(name,1,1) == "@" then return true end
    return false
end

function GetTimeString()
    return "13:12:24"
end

CHAT_CHANNEL_EMOTE = 6
CHAT_CHANNEL_GUILD_1 = 12
CHAT_CHANNEL_GUILD_2 = 13
CHAT_CHANNEL_GUILD_3 = 14
CHAT_CHANNEL_GUILD_4 = 15
CHAT_CHANNEL_GUILD_5 = 16
CHAT_CHANNEL_MONSTER_EMOTE = 10
CHAT_CHANNEL_MONSTER_SAY = 7
CHAT_CHANNEL_MONSTER_WHISPER = 9
CHAT_CHANNEL_MONSTER_YELL = 8
CHAT_CHANNEL_OFFICER_1 = 17
CHAT_CHANNEL_OFFICER_2 = 18
CHAT_CHANNEL_OFFICER_3 = 19
CHAT_CHANNEL_OFFICER_4 = 20
CHAT_CHANNEL_OFFICER_5 = 21
CHAT_CHANNEL_PARTY = 3
CHAT_CHANNEL_SAY = 0
CHAT_CHANNEL_SYSTEM = 11
CHAT_CHANNEL_UNUSED_1 = 5
CHAT_CHANNEL_USER_CHANNEL_1 = 22
CHAT_CHANNEL_USER_CHANNEL_2 = 23
CHAT_CHANNEL_USER_CHANNEL_3 = 24
CHAT_CHANNEL_USER_CHANNEL_4 = 25
CHAT_CHANNEL_USER_CHANNEL_5 = 26
CHAT_CHANNEL_USER_CHANNEL_6 = 27
CHAT_CHANNEL_USER_CHANNEL_7 = 28
CHAT_CHANNEL_USER_CHANNEL_8 = 29
CHAT_CHANNEL_USER_CHANNEL_9 = 30
CHAT_CHANNEL_WHISPER = 2
CHAT_CHANNEL_WHISPER_SENT = 4
CHAT_CHANNEL_YELL = 1
CHAT_CHANNEL_ZONE = 31
CHAT_CHANNEL_ZONE_LANGUAGE_1 = 32
CHAT_CHANNEL_ZONE_LANGUAGE_2 = 33
CHAT_CHANNEL_ZONE_LANGUAGE_3 = 34
CHAT_CHANNEL_ZONE_LANGUAGE_4 = 35

ITEM_LINK_TYPE = "item"
ACHIEVEMENT_LINK_TYPE = "achievement"
CHARACTER_LINK_TYPE = "character"
CHANNEL_LINK_TYPE = "channel"
BOOK_LINK_TYPE = "book"
DISPLAY_NAME_LINK_TYPE = "display"
URL_LINK_TYPE = "url"
COLLECTIBLE_LINK_TYPE = "collectible"
GUILD_LINK_TYPE = "guild"
HELP_LINK_TYPE = "help"

ZO_VALID_LINK_TYPES_CHAT =
{
    [GUILD_LINK_TYPE] = true,
    [ITEM_LINK_TYPE] = true,
    [ACHIEVEMENT_LINK_TYPE] = true,
    [COLLECTIBLE_LINK_TYPE] = true,
    [HELP_LINK_TYPE] = true,
}

function ZO_LinkHandler_ParseLink(link)
    if type(link) == "string" then
        local linkStyle, data, text = link:match("|H(.-):(.-)|h(.-)|h")
        return text, linkStyle, zo_strsplit(':', data)
    end
end
