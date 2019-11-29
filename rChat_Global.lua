-- This is always the first source file loaded so that
-- it can create the addon table/namespace.

-- It also loads strings for the proper language.


local SF = LibSFUtils
 
rChat = {
    name = "rChat",
    version = "1.0",
    settingName = "rChat",
    settingDisplayName = "rChat",
    author = "Shadowfen",
    savedvar = "RCHAT_OPTS",
    sv_version = 1,
}
rChat.settingDisplayName = SF.GetIconized(rChat.settingDisplayName, SF.colors.gold.hex)
rChat.version = SF.GetIconized(rChat.version, SF.colors.gold.hex)
rChat.author = SF.GetIconized(rChat.author, SF.colors.purple.hex)

SF.LoadLanguage(rChat_localization_strings, "en")

rChat.data = {
    cachedMessages = {}, -- This must be init before OnAddonLoaded because it will receive data before this event.
}
