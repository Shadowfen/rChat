-- This is always the first source file loaded so that
-- it can create the addon table/namespace.

-- It also loads strings for the proper language.


local SF = LibSFUtils

rChat = {
    name = "rChat",
    version = SF.colors.gold:Colorize("1.48"),
    settingName = "rChat",
    settingDisplayName = SF.colors.gold:Colorize("rChat"),
    author =  SF.colors.purple:Colorize("Shadowfen"),
    savedvar = "RCHAT_OPTS",
    sv_version = 2,
    evtmgr = SF.EvtMgr:New("rChat")
}

rChat_Logger = SF.SafeLoggerFunction(rChat, "logger", "rChat")

SF.LoadLanguage(rChat_localization_strings, "en")

rChat.data = {
    cachedMessages = {}, -- This must be init before OnAddonLoaded because it will receive data before this event.
}

