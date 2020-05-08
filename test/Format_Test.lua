require "rChat.test.tk"
require "rChat.test.zos"
require "LibSFUtils.LibSFUtils_Global"
require "LibSFUtils.LibSFUtils"
require "LibSFUtils.SFUtils_VersionChecker"
require "LibSFUtils.SFUtils_LoadLanguage"
require "rChat.lang.en"
require "rChat.rChat_Global"
require "rChat.rChat_Utils"
require "rChat.rChatData.rChatData"
require "rChat.rChat_Internals"
local TK = TestKit
local SF = LibSFUtils

local TR = test_run
local d = print

local mn = "Format"

local guildTags = {
    ["Ghost Sea Trading"] = "Ghost",
    ["Eight Shadows of Murder"] = "ESM",
    ["Women of Ebonheart"] = "WoE",
    ["Dreadlords"] = "Dreads",
    ["House Mazkein"] = "Maz",
}
local officertag = {
    ["Ghost Sea Trading"] = "oGhost",
    ["Eight Shadows of Murder"] = "oESM",
    ["Women of Ebonheart"] = "oWoE",
    ["Dreadlords"] = "oDreads",
    ["House Mazkein"] = "oMaz",
}

function initDb()
    local gTags = SF.deepCopy(guildTags)
    local otag = SF.deepCopy(officertag)
    local db = { 
        mention = {
            mentionEnabled = false,
            mentiontbl = {},
            soundEnabled = false,
            colorEnabled = false,
            color = "|cFFFFFF",
        },
        showTimestamp = true,
        timestampcolorislcol = false,
        timestampFormat = "HH:m",
        showGuildNumbers = false,
    }
    db["guildTags"] = gTags
    db["officertag"] = otag
    --dbg(db)
    return db
end
rChat.save = initDb()
local db = rChat.save

---------------------------------
-- utility functions

local L = GetString
------------------------------------------------------
-- bring in rChat_Internals functions
local GetChannelColors = rChat_Internals.GetChannelColors
local GetGuildIndex = rChat_Internals.GetGuildIndex
local formatLanguageTag = rChat_Internals.formatLanguageTag
local formatSeparator = rChat_Internals.formatSeparator
local formatTag = rChat_Internals.formatTag
local formatTimestamp = rChat_Internals.formatTimestamp
local formatText = rChat_Internals.formatText
local formatWhisperTag = rChat_Internals.formatWhisperTag
local formatZoneTag = rChat_Internals.formatZoneTag
local produceCopyFrom = rChat_Internals.produceCopyFrom
local produceDisplayString = rChat_Internals.produceDisplayString
local produceRawString = rChat_Internals.produceRawString
local UseNameFormat = rChat_Internals.UseNameFormat

---------------------------------
-- test functions
local function Format_testGetGuildIndex()
    local fn = "testGetGuildIndex"
    TK.printSuite(mn,fn)

    local guildndx = GetGuildIndex(CHAT_CHANNEL_GUILD_1)
    TK.assertTrue(guildndx == 1, "got index for guild 1")
end

local function Format_testGetNameLink()
    local fn = "testGetNameLink"
    TK.printSuite(mn,fn)

    rChat.save = initDb()
    local db = rChat.save
    local rslt = rChat_Internals.GetNameLink("@anchor", "hello@dedfred")
    local expected = "|H1:display:@anchor|h[hello@dedfred]|h"
    TK.assertNotNil(rslt, "got display link")
    TK.assertTrue(rslt == expected, "got "..rslt)

    rslt = rChat_Internals.GetNameLink("anchor", "hello")
    expected = "|H1:character:anchor|h[hello]|h"
    TK.assertNotNil(rslt, "got character link")
    TK.assertTrue(rslt == expected, "got "..rslt)

    rslt = rChat_Internals.GetNameLink("@anchor", "hello@dedfred", true)
    expected = "|H0:display:@anchor|hhello@dedfred|h"
    TK.assertNotNil(rslt, "got display link")
    TK.assertTrue(rslt == expected, "got "..rslt)

    db.disableBrackets = true
    rslt = rChat_Internals.GetNameLink("anchor", "hello")
    expected = "|H0:character:anchor|hhello|h"
    TK.assertNotNil(rslt, "got character link")
    TK.assertTrue(rslt == expected, "got "..rslt)

end

local function Format_testFormatLanguageTag()
    local fn = "testFormatLanguageTag"
    TK.printSuite(mn,fn)

    local entry, ndx = rChatData.getNewCacheEntry(CHAT_CHANNEL_ZONE_LANGUAGE_3)
    entry.rawT = {}
    entry.displayT = {}

    local tag = formatLanguageTag(entry,ndx)
    TK.assertNotNil(tag,"new language tag exists")
    TK.assertTrue(tag == "[DE] ","language tag is '[DE] ' ("..tag..")")

    entry, ndx = rChatData.getNewCacheEntry(CHAT_CHANNEL_WHISPER)

    tag = rChat_Internals.formatLanguageTag(entry,ndx)
    TK.assertNil(tag,"language tag does not exist for CHAT_CHANNEL_WHISPER")
end

local function Format_testFormatSeparator()
    local fn = "testFormatSeparator"
    TK.printSuite(mn,fn)

    rChat.save = initDb()
    local db = rChat.save
    local entry, ndx = rChatData.getNewCacheEntry(CHAT_CHANNEL_WHISPER_SENT)
    entry.rawT = {}
    entry.displayT = {}

    local sep = rChat_Internals.formatSeparator(entry,ndx)
    TK.assertNotNil(sep,"new separator exists")
    TK.assertTrue(sep == ": ","separator is ': ' ("..sep..")")

    db.carriageReturn = true
    sep = rChat_Internals.formatSeparator(entry,ndx)
    TK.assertNotNil(sep,"cr separator exists")
    TK.assertTrue(sep == ":\n","separator is ':\\n' ("..sep..")")
end

-- helper for testFormatTag tests
local function guildTest(entry, ndx, channel, gtag)
    local tag, raw = formatTag(entry, ndx)
    local linkfmt = "|H1:channel:%d|h%s|h "

    TK.assertNotNil(tag,"new guild tag exists")
    local expectedDsp = string.format(linkfmt,channel,gtag)
    TK.assertTrue(tag == expectedDsp, string.format("zone tag is '%s' (%s)",tag,expectedDsp))

    local expectedR = string.format("%s ",gtag)
    TK.assertTrue(raw == expectedR,string.format("raw zone tag is '%s' (%s)",tag, expectedR))
end

local function Format_testFormatTag_brackets()
    local fn = "testFormatTag_brackets"
    TK.printSuite(mn,fn)

    rChat.save = initDb()
    local db = rChat.save

    local entry, ndx = rChatData.getNewCacheEntry(CHAT_CHANNEL_GUILD_3)

    db.showGuildNumbers = false
    guildTest(entry, ndx, CHAT_CHANNEL_GUILD_3, "[WoE]")

    db.showGuildNumbers = true
    guildTest(entry, ndx, CHAT_CHANNEL_GUILD_3, "[3-WoE]")

    entry, ndx = rChatData.getNewCacheEntry(CHAT_CHANNEL_OFFICER_3)

    db.showGuildNumbers = false
    guildTest(entry, ndx, CHAT_CHANNEL_OFFICER_3, "[oWoE]")

    db.showGuildNumbers = true
    guildTest(entry, ndx, CHAT_CHANNEL_OFFICER_3, "[3-oWoE]")

    db.showGuildNumbers = false
end

local function Format_testFormatTag_nobrackets()
    local fn = "testFormatTag_nobrackets"
    TK.printSuite(mn,fn)

    rChat.save = initDb()
    local db = rChat.save
    db.disableBrackets = true   -- does not affect guild brackets, only player

    local entry, ndx = rChatData.getNewCacheEntry(CHAT_CHANNEL_GUILD_3)

    db.showGuildNumbers = false
    guildTest(entry, ndx, CHAT_CHANNEL_GUILD_3, "[WoE]")

    db.showGuildNumbers = true
    guildTest(entry, ndx, CHAT_CHANNEL_GUILD_3, "[3-WoE]")

    entry, ndx = rChatData.getNewCacheEntry(CHAT_CHANNEL_OFFICER_3)

    db.showGuildNumbers = false
    guildTest(entry, ndx, CHAT_CHANNEL_OFFICER_3, "[oWoE]")

    db.showGuildNumbers = true
    guildTest(entry, ndx, CHAT_CHANNEL_OFFICER_3, "[3-oWoE]")

    db.showGuildNumbers = false
    db.disableBrackets = false
end

local function Format_testFormatWhisper()
    local fn = "testFormatWhisper"
    TK.printSuite(mn,fn)

    local entry, ndx = rChatData.getNewCacheEntry(CHAT_CHANNEL_WHISPER_SENT)
    entry.rawT = {}
    entry.displayT = {}

    local sep = formatWhisperTag(entry,ndx)
    TK.assertNotNil(sep,"new sent separator exists")
    TK.assertTrue(sep == "-> ","sent separator is '-> ' ("..sep..")")

    entry, ndx = rChatData.getNewCacheEntry(CHAT_CHANNEL_WHISPER)
    entry.rawT = {}
    entry.displayT = {}

    sep = rChat_Internals.formatWhisperTag(entry,ndx)
    TK.assertNotNil(sep,"new whisp separator exists")
    TK.assertTrue(sep == "","whisp separator is '' ("..sep..")")
end

local function Format_testFormatZoneTag()
    local fn = "testFormatZoneTag"
    TK.printSuite(mn,fn)

    rChat.save = initDb()
    local db = rChat.save
    
    local entry, ndx = rChatData.getNewCacheEntry(CHAT_CHANNEL_SAY)

    local tag = formatZoneTag(entry, ndx)
    TK.assertNotNil(tag,"new zone tag exists")
    local expected = string.format(" |H1:p:%d:%d|h[%s]|h",ndx, CHAT_CHANNEL_SAY,"says")
    TK.assertTrue(tag == expected,"zone tag is ' |H1:p:6:0|h[says]|h' ("..expected..")")

    entry, ndx = rChatData.getNewCacheEntry(CHAT_CHANNEL_WHISPER)

    tag = rChat_Internals.formatZoneTag(entry,ndx)
    TK.assertNil(tag,"zone tag does not exist for CHAT_CHANNEL_WHISPER")
end

local function Format_testFormatZoneTag_party()
    local fn = "testFormatZoneTag_party"
    TK.printSuite(mn,fn)

    local entry, ndx = rChatData.getNewCacheEntry(CHAT_CHANNEL_PARTY)

    local ltag, ztag, pltag, ptag = formatZoneTag(entry, ndx)
    TK.assertNotNil(pltag,"new party tag exists")
    local expected = string.format("|H1:p:%d:%d|h[%s]|h ",ndx, CHAT_CHANNEL_PARTY,"Group")
    TK.assertTrue(pltag == expected, string.format("party tag is '%s' (%s)",pltag,expected))
end

local function Format_testProduceRawString_say()
    local fn = "testProduceRawString_say"
    TK.printSuite(mn,fn)

    rChat.save = initDb()
    local db = rChat.save

    db.showTimestamp = true
    db.timestampFormat = "HH:m"
    local entry, ndx = rChatData.getNewCacheEntry(CHAT_CHANNEL_SAY)
    entry.from = "Lost And Confused"
    entry.text = "Where is a pack merchant?"

    local displayT = {
        from = entry.from,
        text = entry.text,
    }
    local rawT = {
        from = entry.from,
        text = entry.text,
    }

    displayT.timestamp, rawT.timestamp = formatTimestamp(entry, ndx)
    displayT.separator, rawT.separator = formatSeparator(entry, ndx)
    displayT.language, rawT.language = formatLanguageTag(entry, ndx)
    displayT.whisper, rawT.whisper = formatWhisperTag(entry, ndx)
    displayT.zonetag, rawT.zonetag = formatZoneTag(entry, ndx)
    displayT.tag, rawT.tag = formatTag(entry, ndx)
    displayT.text, rawT.text = formatText(entry, ndx)

    local rawstr = produceRawString(entry, ndx, rawT)
    local expected = "[13:12] Lost And Confused says: Where is a pack merchant?"
    d("got:      "..rawstr)
    d("expected: "..expected)
    TK.assertTrue(rawstr == expected, "got the correct raw message ("..rawstr..")")

    db.showTimestamp = false
    displayT.timestamp, rawT.timestamp = formatTimestamp(entry, ndx)
    rawstr = produceRawString(entry, ndx, rawT)
    expected = "Lost And Confused says: Where is a pack merchant?"
    TK.assertTrue(rawstr == expected, "got the correct raw message 2 ("..rawstr..")")
end


local function Format_testProduceRawString_guild()
    local fn = "testProduceRawString"
    TK.printSuite(mn,fn)

    rChat.save = initDb()
    local db = rChat.save
    db.showTimestamp = true
    db.timestampFormat = "HH:m"

    local entry, ndx = rChatData.getNewCacheEntry(CHAT_CHANNEL_GUILD_2)
    entry.from = "Will Die Soon"
    entry.text = "Anyone want to do a pledge?"

    local display = {
        from = entry.from,
        text = entry.text,
    }
    local raw = {
        from = entry.from,
        text = entry.text,
    }

    display.timestamp, raw.timestamp = formatTimestamp(entry, ndx)
    display.separator, raw.separator = formatSeparator(entry, ndx)
    display.language, raw.language = formatLanguageTag(entry, ndx)
    display.whisper, raw.whisper = formatWhisperTag(entry, ndx)
    display.zonetag, raw.zonetag = formatZoneTag(entry, ndx)
    display.tag, raw.tag = formatTag(entry, ndx)

    local rawstr = produceRawString(entry, ndx, raw)
    local expected = "[13:12] [ESM] Will Die Soon: Anyone want to do a pledge?"
    TK.assertTrue(rawstr == expected, "got the correct raw message ("..rawstr..")")

    db.showGuildNumbers = true
    display.tag, raw.tag = formatTag(entry, ndx)
    rawstr = produceRawString(entry, ndx, raw)
    expected = "[13:12] [2-ESM] Will Die Soon: Anyone want to do a pledge?"
    TK.assertTrue(rawstr == expected, "got the correct raw message 2 ("..rawstr..")")
end

local function Format_testFormatName()
    local fn = "testFormatName"
    TK.printSuite(mn,fn)

    rChat.save = initDb()
    local db = rChat.save
end

local function Format_testFormatText()
    local fn = "testFormatText"
    TK.printSuite(mn,fn)

    rChat.save = initDb()
    local db = rChat.save
    TK.assertTrue(true,"Not yet implemented")
end

local function Format_testProduceDisplayString_guild()
    local fn = "testProduceDisplayString_guild"
    TK.printSuite(mn,fn)

    rChat.save = initDb()
    local db = rChat.save
    
    db.showTimestamp = true
    db.timestampFormat = "HH:m"
    local entry, ndx = rChatData.getNewCacheEntry(CHAT_CHANNEL_SAY)
    entry.from = "Lost And Confused"
    entry.text = "Where is a vendor?"

    local display = {
        from = entry.from,
        text = entry.text,
    }
    local raw = {
        from = entry.from,
        text = entry.text,
    }
    entry.displayT = display
    entry.rawT = raw

    display.timestamp, raw.timestamp = formatTimestamp(entry, ndx)
    display.separator, raw.separator = formatSeparator(entry, ndx)
    display.language, raw.language = formatLanguageTag(entry, ndx)
    display.whisper, raw.whisper = formatWhisperTag(entry, ndx)
    display.zonetag, raw.zonetag = formatZoneTag(entry, ndx)
    display.tag, raw.tag = formatTag(entry, ndx)

    local colorT = {
        timecol = "|cAAFFFF",
        lcol = "|cBBFFFF",
        rcol = "|cCCFFFF",
        mentioncol = "|cDDFFFF",
    }

    local str = produceDisplayString(entry, ndx, display,colorT)
    local expected = string.format("%s%s|r%s%s%s|r: %sWhere is a vendor?|r", colorT.timecol,display.timestamp, colorT.lcol,display.from, display.zonetag, colorT.rcol)
    d("   expected: "..expected)
    d("        got: "..str)
    TK.assertTrue(str == expected, "got the correct message")

end

local function Format_testProduceDisplayString_say()
    local fn = "testProduceDisplayString_say"
    TK.printSuite(mn,fn)

    rChat.save = initDb()
    local db = rChat.save
    
    local entry, ndx = rChatData.getNewCacheEntry(CHAT_CHANNEL_SAY)
    entry.from = "Lost And Confused"
    entry.text = "Where is a pack merchant?"

    local display = {
        from = entry.from,
        text = entry.text,
    }
    local raw = {
        from = entry.from,
        text = entry.text,
    }

    display.timestamp, raw.timestamp = formatTimestamp(entry, ndx)
    display.separator, raw.separator = formatSeparator(entry, ndx)
    display.language, raw.language = formatLanguageTag(entry, ndx)
    display.whisper, raw.whisper = formatWhisperTag(entry, ndx)
    display.zonetag, raw.zonetag = formatZoneTag(entry, ndx)
    display.tag, raw.tag = formatTag(entry, ndx)

    local colorT = {
        timecol = "|cAAAAAA",
        lcol = "|cBBBBBB",
        rcol = "|cCCCCCC",
        mentioncol = "|cDDDDDD",
    }
    
    db.delzonetags = false

    local str = produceDisplayString(entry, ndx, display, colorT)
    local expected = string.format("%s%s|r%s%s%s|r: %sWhere is a pack merchant?|r", colorT.timecol,display.timestamp, colorT.lcol,display.from, display.zonetag,colorT.rcol)
    d("   expected: "..expected)
    d("        got: "..str)
    TK.assertTrue(str == expected, "got the correct message")

    db.showTimestamp = false
    display.timestamp, raw.timestamp = formatTimestamp(entry, ndx)
    str = produceDisplayString(entry, ndx, display, colorT)
    expected = string.format("%s%s%s|r: %sWhere is a pack merchant?|r", colorT.lcol,display.from, display.zonetag,colorT.rcol)
    --expected = "|cBBBBBBLost And Confused |H1:p:13:0|h[says]|h|r: |CCCCCCWhere is a pack merchant?|r"
    d("   expected: "..expected)
    d("        got: "..str)
    TK.assertTrue(str == expected, "got the correct message 2 ("..str..")")
end

local function Format_testUseNameFormat()
    local fn = "testUseNameFormat"
    TK.printSuite(mn,fn)

    TK.assertTrue("@lost" == UseNameFormat("@lost","Where am I", nil, 1), "1 - @lost" )
    TK.assertTrue("Where am I" == UseNameFormat("@lost","Where am I", nil, 2), "2 - Where am I")
    TK.assertTrue("Where am I@lost" == UseNameFormat("@lost","Where am I", nil, 3), "3 - Where am I@lost")
    TK.assertTrue("Where am I(@lost)" == UseNameFormat("@lost","Where am I", nil, 4), "4 - Where am I(@lost)")
    TK.assertTrue("Fred" == UseNameFormat("@lost","Where am I", "Fred", 4), "0 - Fred")

    TK.assertTrue("Where am I" == UseNameFormat(nil,"Where am I", nil, 1), "1 degraded -> Where am I" )
    TK.assertTrue("@lost" == UseNameFormat("@lost",nil, nil, 2), "2 degraded -> @lost")
    TK.assertTrue("@lost" == UseNameFormat("@lost",nil, nil, 3), "3 degraded -> @lost")
    TK.assertTrue("Where am I" == UseNameFormat(nil,"Where am I", nil, 3), "3 degraded -> Where am I")
    TK.assertTrue("@lost" == UseNameFormat("@lost",nil, nil, 4), "4 degraded -> @lost")
    TK.assertTrue("Where am I" == UseNameFormat(nil,"Where am I", nil, 4), "4 degraded -> Where am I")

end

local function Format_testProcessLinks_bare()
    local fn = "testProcessLinks_bare"
    TK.printSuite(mn,fn)

    rChat.save = initDb()
    local db = rChat.save
    
    local entry, ndx = rChatData.getNewCacheEntry(CHAT_CHANNEL_SAY)
    
    local rslts
    rslts = rChat_Internals.processLinks(entry,"This is a test of a bare msg")
    TK.assertNotNil(rslts, "got results for bare msg")
    TK.assertTrue(#rslts == 1, "only have one entry for bare string")
    TK.assertNotNil(rslts[1])
    TK.assertTrue(rslts[1][1] == "This is a test of a bare msg", "got the correct msg entry")
    TK.assertTrue(rslts[1][2] == 0, "known to be bare text")
end

local function Format_testProcessLinks_item()
    local fn = "testProcessLinks_item"
    TK.printSuite(mn,fn)

    rChat.save = initDb()
    local db = rChat.save
    
    local entry, ndx = rChatData.getNewCacheEntry(CHAT_CHANNEL_SAY)
    
    local rslts
    rslts = rChat_Internals.processLinks(entry,"This is a test of a |H0:item:xx:0:0:0:0:0|hlinked|h msg")
    TK.assertNotNil(rslts, "got results for linked msg")
    TK.assertTrue(#rslts == 3, "have 3 entries for linked string")
    TK.assertTrue(rslts[1][1] == "This is a test of a ", "got the correct msg 1 entry")
    TK.assertTrue(rslts[1][2] == 0, "known to be bare text")
    TK.assertTrue(rslts[2][1] == "|H0:item:xx:0:0:0:0:0|hlinked|h", "got the correct msg 2 entry")
    TK.assertTrue(rslts[2][2] == 2, "known to be link handler 2")
    TK.assertTrue(rslts[3][1] == " msg", "got the correct msg 3 entry")
    TK.assertTrue(rslts[3][2] == 0, "known to be bare 3 text")
end

local function Format_testGetChannelColors()
    local fn = "testGetChannelColors"
    TK.printSuite(mn,fn)

    rChat.save = initDb()
    local db = rChat.save
end

local function Format_testGetColors()
    local fn = "testGetColors"
    TK.printSuite(mn,fn)

    rChat.save = initDb()
    local db = rChat.save
end

local function Format_testInitColorTable()
    local fn = "testInitColorTable"
    TK.printSuite(mn,fn)

    rChat.save = initDb()
    local db = rChat.save
end

local function Format_testProduceCopyFrom()
    local fn = "testProduceCopyFrom"
    TK.printSuite(mn,fn)

    rChat.save = initDb()
    local db = rChat.save
end

function Format_runTests()
    rChatData.initCache()
    rChatData.clearCache()
    --Format_testGetChannelColors()
    --Format_testGetColors()
    Format_testGetGuildIndex()
    Format_testGetNameLink()
    Format_testFormatLanguageTag()
    --Format_testFormatName()
    Format_testFormatSeparator()
    Format_testFormatTag_brackets()
    Format_testFormatTag_nobrackets()
    --Format_testFormatText()
    --Format_testFormatTimestamp()
    Format_testFormatWhisper()
    Format_testFormatZoneTag()
    Format_testFormatZoneTag_party()
    --Format_testInitColorTable()
    Format_testProcessLinks_bare()
    Format_testProcessLinks_item()
    --Format_testProduceCopyFrom()
    Format_testProduceDisplayString_say()
    Format_testProduceDisplayString_guild()
    Format_testProduceRawString_say()
    Format_testProduceRawString_guild()
    --Format_testProduceString_guild()
    Format_testUseNameFormat()

end

-- main
if not Suite then
    Format_runTests()
    d("\n")
    TK.showResult("Format_Test")
end
