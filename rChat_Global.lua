-- This is always the first source file loaded so that
-- it can create the addon table/namespace.

-- It also loads strings for the proper language.


local SF = LibSFUtils
 
rChat = {
    name = "rChat",
    version = "1.4.3",
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

-- checks the versions of libraries (where possible) and warn in
-- debug logger if we detect out of date libraries.
function rChat.checkLibraryVersions()
    if not LibDebugLogger then return end
    
    local addonName = rChat.name
    local logger = LibDebugLogger(addonName)
    
    local function versionCheck(libname, version, expectedVersion, isLibStub)
        if not libname or not expectedVersion then return end
        if not isLibStub and not _G[libname] then
            logger:Error("Missing required library %s: was not loaded prior to %s!", libname, addonName)
            return
        end
        if not version or version < expectedVersion then
            logger:Error("Outdated version of %s detected (%d) - possibly embedded in another older addon.", libname, version or -1) 
        end
    end
    
    -- check the libraries that still support LibStub
    -- because there we can get versions through a standard 
    -- mechanism.
    if LibStub then 
        local function checkLS(name, expected)
            local lib, ver
            lib, ver = LibStub:GetLibrary(name)
            versionCheck(name, ver, expected, true)
        end

        checkLS("LibAddonMenu-2.0", 30)
        checkLS("LibMediaProvider-1.0", 12)
        checkLS("libChat-1.0", 12)
    end
    
    -- check libraries that do not use LibStub
    versionCheck("LibSFUtils", LibSFUtils.LibVersion, 22)
    
    logger:Info("Library %s does not provide version information", "LibDebugLogger")
end

