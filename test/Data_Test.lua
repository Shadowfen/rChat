require "rChat.test.tk"
require "rChat.test.zos"
require "LibSFUtils.LibSFUtils_Global"
require "LibSFUtils.SFUtils_Color"
require "LibSFUtils.SFUtils_Events"
require "LibSFUtils.LibSFUtils"
require "LibSFUtils.SFUtils_VersionChecker"
require "LibSFUtils.SFUtils_LoadLanguage"
require "LibSFUtils.SFUtils_Logger"
require "rChat.rChat_Global"
require "rChat.rChatData.rChatData"
local TK = TestKit
local SF = LibSFUtils

SF.EvtMgr.evtnames = {}


local TR = test_run
local d = print

local moduleName = "Data"
local mn = "Data"

---------------------------------
-- utility functions
local function populateNewCache()
    rChatData.clearCache()
    rChatData.initCache()
    -- first entry
    rChatData.SetLine({
        timestamp = 1234,    --[1]
        channel = 7,      --[2]   the channel that the message was on
        from = "@Bob",         --[3]   the sender of the message (not really raw)
        message = "This is a test",      --[4]   the text of the message
        line = "[11:56] @Bob: This is a test",         --[5]   includes timestamp, from, channel, message, etc
        displayed = "[11:56] |cffffff@Bob|r: This is a test", --[6]   what actually gets printed to the chat window
        })
    -- second entry
    rChatData.SetLine({
        timestamp = 1235,    --[1]
        channel = 6,      --[2]   the channel that the message was on
        from = "@Bobbie",         --[3]   the sender of the message (not really raw)
        message = "This not is a test",      --[4]   the text of the message
        line = "[11:57] @Bobbie: This not is a test",         --[5]   includes timestamp, from, channel, message, etc
        displayed = "[11:57] |cffffff@Bobbie|r: This not is a test", --[6]   what actually gets printed to the chat window
    })
    -- third entry
    rChatData.SetLine({
        timestamp = 1236,    --[1]
        channel = 5,      --[2]   the channel that the message was on
        from = "@Adam",         --[3]   the sender of the message (not really raw)
        message = "Help!",      --[4]   the text of the message
        line = "[11:58] @Adam: Help!",         --[5]   includes timestamp, from, channel, message, etc
        displayed = "[11:58] |cffffff@Adam|r: Help!", --[6]   what actually gets printed to the chat window
    })
end

---------------------------------
-- test functions

local function Cache_testInitCache()
    local fn = "testInitCache"
    TK.printSuite(mn,fn)

    rChatData.initCache()
    TK.assertNotNil(rChatData.cache.Entries,"new Entries table exists")
    TK.assertTrue(type(rChatData.cache.Entries) == "table", "new Entries is a table")
    TK.assertTrue(rChatData.cache.lineNumber == 1,"next entry is 1")
end

local function Cache_testFilterSize()
    local fn = "testFilterSize"
    TK.printSuite(mn,fn)

    rChatData.cache.Entries = { 
        { channel=6, timestamp = 100, message = "one",}, 
        { channel=6, timestamp = 200, message = "two",}, 
        { channel=6, timestamp = 300, message = "three",}, 
        { channel=6, timestamp = 400, message = "four",}, 
        { channel=6, timestamp = 500, message = "five",}, 
    }
    rChatData.cache.lineNumber = #rChatData.cache.Entries + 1
    local rslt = rChatData.filterSize(4, 3)
    TK.assertNotNil(rslt,"got truncated table")
    TK.assertTrue(#rslt == 3,#rslt)
    TK.assertTrue(rslt[1].message == "three","[1] = three")
    TK.assertTrue(rslt[2].message == "four","[2] = four")
    TK.assertTrue(rslt[3].message == "five","[3] = five")
    TK.assertTrue(rChatData.cache.lineNumber == 4, "lineNumber set to 4 ("..rChatData.cache.lineNumber..")")
end

local function Cache_testFilterAged()
    local fn = "testFilterAged"
    TK.printSuite(mn,fn)

    local currentTime= GetTimeStamp()
    rChatData.cache.Entries = { 
        { channel=6, timestamp = currentTime - 500, message = "one",}, 
        { channel=6, timestamp = currentTime - 400, message = "two",}, 
        { channel=6, timestamp = currentTime - 300, message = "three",}, 
        { channel=6, timestamp = currentTime - 200, message = "four",}, 
        { channel=6, timestamp = currentTime - 100, message = "five",}, 
    }
    rChatData.cache.lineNumber = #rChatData.cache.Entries + 1
    local rslt = rChatData.filterAged(300)
    TK.assertNotNil(rslt,"got filter aged table")
    TK.assertTrue(#rslt == 3,#rslt)
    TK.assertTrue(rslt[1].message == "three","[1] = three")
    TK.assertTrue(rslt[2].message == "four","[2] = four")
    TK.assertTrue(rslt[3].message == "five","[3] = five")
    TK.assertTrue(rChatData.cache.lineNumber == 4, "lineNumber set to 4 ("..rChatData.cache.lineNumber..")")
end

local function Cache_testFilterChannels()
    local fn = "testFilterAged"
    TK.printSuite(mn,fn)

    rChatData.cache.Entries = {
        { channel=6, timestamp = 100, message = "one",}, 
        { channel=11, timestamp = 200, message = "two",}, 
        { channel=6, timestamp = 300, message = "three",}, 
        { channel=11, timestamp = 400, message = "four",}, 
        { channel=6, timestamp = 500, message = "five",}, 
    }
    rChatData.cache.lineNumber = #rChatData.cache.Entries + 1
    local exclude = {
        [11] = true,
    }
    local rslt = rChatData.filterChannels(exclude)
    TK.assertNotNil(rslt,"got filter channels table")
    TK.assertTrue(#rslt == 3,#rslt)
    TK.assertTrue(rslt[1].message == "one","[1] = one")
    TK.assertTrue(rslt[2].message == "three","[2] = three")
    TK.assertTrue(rslt[3].message == "five","[3] = five")
    TK.assertTrue(rChatData.cache.lineNumber == 4, "lineNumber set to 4 ("..rChatData.cache.lineNumber..")")
end

local function Cache_testNewEntry()
    local fn = "testNewEntry"
    TK.printSuite(mn, fn)

    local sttime = os.time()
    local entry = rChatData.getNewCacheEntry(6)
    local etime = os.time()
    TK.assertNotNil(entry,"got new entry")
    TK.assertNotNil(entry.channel, "has a channel")
    TK.assertTrue(entry.channel == 6, "channel set to 6")
    TK.assertNotNil(entry.timestamp,"has a timestamp")
    TK.assertTrue(entry.timestamp >= sttime, "entry timestamp >= start")
    TK.assertTrue(entry.timestamp <= etime, "entry timestamp <= end")
    TK.assertTrue(rChatData.cache.lineNumber == 2, "nextline position == 2")
    TK.assertTrue(rChatData.cache.Entries[1] == entry, "new entry is inside Entries")
end

local function Cache_testGetLine()
    local fn = "testGetLine"
    TK.printSuite(mn,fn)
    populateNewCache()
    TK.assertTrue(rChatData.cache.lineNumber == 4, "cache is populated "..rChatData.cache.lineNumber)

    fn = "  testGetLine_last"
    TK.printSuite(mn,fn)
    local entry, ndx = rChatData.getCacheEntry(3)  -- "real" last line is always empty - lineNumber == 4 here
    TK.assertTrue(ndx == 3, "Entry index is 3")
    TK.assertTrue(entry.from == "@Adam", "Entry from is @Adam")

    fn = "  testGetLine_first"
    TK.printSuite(mn,fn)
    entry, ndx = rChatData.getCacheEntry(1)
    TK.assertNotNil(entry, "entry is not nil")
    TK.assertTrue(ndx == 1, "Entry index is 1")
    TK.assertTrue(entry.from == "@Bob", "Entry from is @Bob")

    fn = "  testGetLine_5th"
    TK.printSuite(mn,fn)
    TK.assertTrue(rChatData.cache.lineNumber < 5, "cache doesn't have enough entries")
    entry, ndx = rChatData.getCacheEntry(5)
    TK.assertTrue(ndx == 0, "Entry index is "..ndx)
    TK.assertNil(entry, "No such entry")
end

local function Cache_testSetEntry()
    local fn = "testSetEntry"
    TK.printSuite(mn,fn)

    rChatData.clearCache()   -- start with empty cache

    local froms = {
        [1] = {channel = 6, timestamp = 1234,from="@Bob"},
        [2] = {channel = 6, timestamp = 1235,from="@Bobbie"},
        [3] = {channel = 6, timestamp = 1236,from="@Adam"},
    }

    -- this actually adds the entry with channel and ts
    local entry,index = rChatData.getNewCacheEntry(6)
    -- add more info to the entry
    entry.from = froms[2].from
    entry.timestamp = froms[2].timestamp

    -- now, check the entry in the table
    TK.assertFalse(index == 0,"cache is empty")
    TK.assertTrue(index == 1,"table has at least one entry")
    TK.assertTrue(rChatData.cache.lineNumber == 2, "next line will be "..rChatData.cache.lineNumber)

    entry = rChatData.cache.Entries[index]
    TK.assertNotNil(entry, "retrieved entry "..index)
    TK.assertTrue(entry.channel == froms[2].channel, "channel is correct")
    TK.assertTrue(entry.timestamp == froms[2].timestamp, "timestamp is correct "..entry.timestamp)
    TK.assertTrue(entry.from == froms[2].from, "from is correct "..entry.from)
end

local function Cache_testIterCache()
    local fn = "testIterCache"
    TK.printSuite(mn,fn)

    local froms = {
        [1] = {channel = 6, timestamp = 1234,from="@Bob"},
        [2] = {channel = 6, timestamp = 1235,from="@Bobbie"},
        [3] = {channel = 6, timestamp = 1236,from="@Adam"},
    }    
    rChatData.cache.Entries = froms
    rChatData.cache.lineNumber = 4
    
    for ndx, entry in rChatData.iterCache() do
        TK.assertNotNil(entry, "retrieved entry "..ndx)
        TK.assertTrue(entry == froms[ndx], "entry is equal "..ndx)
        TK.assertTrue(entry.channel == froms[ndx].channel, "channel is correct "..ndx)
        TK.assertTrue(entry.timestamp == froms[ndx].timestamp, "timestamp is correct "..ndx)
        TK.assertTrue(entry.from == froms[ndx].from, "from is correct "..ndx)
    end
end

local function Cache_testClearCache()
    local fn = "testClearCache"
    TK.printSuite(mn,fn)
    populateNewCache()

    rChatData.clearCache()
    TK.assertTrue(type(rChatData.cache.Entries) == "table","Valid Entries table")
    TK.assertNil(next(rChatData.cache.Entries), "Table is empty")
    TK.assertTrue(rChatData.cache.lineNumber == 1, "lineNumber == 1")
end



function Data_runTests()
    Cache_testInitCache()
    Cache_testNewEntry()
    Cache_testFilterSize()
    Cache_testFilterAged()
    Cache_testFilterChannels()
    Cache_testGetLine()
    Cache_testSetEntry()
    Cache_testIterCache()
    Cache_testClearCache()
end

-- main
if not Suite then
    Data_runTests()
    d("\n")
    TK.showResult("Data_Test")
end
