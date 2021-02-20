-- This is always the first source file loaded so that
-- it can create the addon table/namespace.

-- It also loads strings for the proper language.


local SF = LibSFUtils

rChat = {
    name = "rChat",
    version = "1.18",
    settingName = "rChat",
    settingDisplayName = "rChat",
    author = "Shadowfen",
    savedvar = "RCHAT_OPTS",
    sv_version = 2,
}
rChat.settingDisplayName = SF.GetIconized(rChat.settingDisplayName, SF.colors.gold.hex)
rChat.version = SF.GetIconized(rChat.version, SF.colors.gold.hex)
rChat.author = SF.GetIconized(rChat.author, SF.colors.purple.hex)

SF.LoadLanguage(rChat_localization_strings, "en")

rChat.data = {
    cachedMessages = {}, -- This must be init before OnAddonLoaded because it will receive data before this event.
}

rChat_Logger = {
    Error = function(self,...)  self.chatter:systemMessage("ERROR: "..string.format(...)) end,
    Warn = function(self,...)  self.chatter:systemMessage("WARN: "..string.format(...)) end,
    Info = function(self,...)  self.chatter:debugMsg("INFO: "..string.format(...)) end,
    Debug = function(self,...)  self.chatter:debugMsg("DEBUG: "..string.format(...)) end,

    Create = function(self, addon_name)
        local o = {}
        setmetatable(o, self)
        self.__index = self
        o.addonName = addon_name
        o.chatter = SF.addonChatter:New(addon_name)
        return o
    end,

    enableDebug = function(self,...) self.chatter:enableDebug() end,
    disableDebug = function(self,...) self.chatter:disableDebug() end,
    SetEnabled = function(self, val)
            if val == true then
                self.chatter:enableDebug()
            else
                self.chatter:disableDebug()
            end
        end,
}

function rChat.checkLibraryVersions()
    local vc = SF.VersionChecker("rChat")
    local logger = rChat_Logger:Create("rChat")
    vc:Enable(logger)
    vc:CheckVersion("LibAddonMenu-2.0", 30)
    vc:CheckVersion("LibMediaProvider-1.0", 13)
    vc:CheckVersion("LibChatMessage", 100)
    vc:CheckVersion("LibSFUtils", 29)
end
