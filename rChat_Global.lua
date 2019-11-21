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
