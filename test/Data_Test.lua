require "rChat.test.tk"
require "rChat.test.zos"
require "LibSFUtils.LibSFUtils_Global"
require "LibSFUtils.LibSFUtils"
require "LibSFUtils.SFUtils_VersionChecker"
require "LibSFUtils.SFUtils_LoadLanguage"
require "rChat.rChat_Global"
require "rChat.rChatData.rChatData"
local TK = TestKit
local SF = LibSFUtils

local TR = test_run
local d = print

local moduleName = "rChatData"
local mn = "rChatData"


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
    TK.assertNotNil(rChatData.cache.Entries,"new Entries exists")
    TK.assertTrue(type(rChatData.cache.Entries) == "table", "new Entries is a table")
    TK.assertTrue(rChatData.cache.lineNumber == 1,"next entry is 1")
end    

local function Cache_testTruncate()
    local fn = "testTruncate"
    TK.printSuite(mn,fn)
    
    local testtable = { "one", "two", "three", "four", "five" }
    local rslt = rChatData.truncate(testtable, 4, 3)
    TK.assertNotNil(rslt,"got truncated table")
    TK.assertTrue(#rslt == 3,#rslt)
    TK.assertTrue(rslt[1] == "three","[1] = three")
    TK.assertTrue(rslt[2] == "four","[2] = four")
    TK.assertTrue(rslt[3] == "five","[3] = five")
end

local function Cache_testTruncateAged()
    local fn = "testTruncateAged"
    TK.printSuite(mn,fn)
    
    local testtable = { {"one", timestamp = 100}, 
        {"two", timestamp = 200}, {"three", timestamp = 300}, 
        {"four", timestamp = 400}, {"five", timestamp = 500} }
    local rslt = rChatData.truncate(testtable, 6, 5, 200)
    TK.assertNotNil(rslt,"got truncated aged table")
    TK.assertTrue(#rslt == 3,#rslt)
    TK.assertTrue(rslt[1][1] == "three","[1] = three")
    TK.assertTrue(rslt[2][1] == "four","[2] = four")
    TK.assertTrue(rslt[3][1] == "five","[3] = five")
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
    dbg(rChatData.cache.Entries)
    
     fn = "  testGetLine_last"
    TK.printSuite(mn,fn)
    local entry, ndx = rChatData.getCacheEntry(3)  -- "real" last line is always empty - lineNumber == 4 here
    TK.assertTrue(ndx == 3, "Entry index is 3")
    TK.assertTrue(entry.from == "@Adam", "Entry from is @Adam")
    
    fn = "  testGetLine_first"
    TK.printSuite(mn,fn)
    entry, ndx = rChatData.getCacheEntry(1)
    dbg("entry = ",entry," ",ndx)
    TK.assertNotNil(entry, "entry is not nil")
    TK.assertTrue(ndx == 1, "Entry index is 1")
    TK.assertTrue(entry.from == "@Bob", "Entry from is @Bob")
    
    fn = "  testGetLine_5th"
    TK.printSuite(mn,fn)
    entry, ndx = rChatData.getCacheEntry(5)
    TK.assertTrue(ndx == 0, "Entry index is "..ndx)
    TK.assertNil(entry, "No such entry")
end

local function Cache_testSetEntry()
    local fn = "testSetEntry"
    TK.printSuite(mn,fn)
    rChatData.clearCache()   
    
    local froms = {
        [1] = {channel = 6, timestamp = 1234,from="@Bob"},
        [2] = {channel = 6, timestamp = 1235,from="@Bobbie"},
        [3] = {channel = 6, timestamp = 1236,from="@Adam"},
    }
    dbg(froms)
    local entry,index = rChatData.getNewCacheEntry(6)
    entry.from = froms[2].from
    entry.timestamp = froms[2].timestamp
    
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
    Cache_testTruncate()
    Cache_testTruncateAged()
    Cache_testNewEntry()
    Cache_testGetLine()
    Cache_testSetEntry()
    Cache_testIterCache()
    Cache_testClearCache()
end

-- main
Data_runTests()


d("\n")
TK.showResult()
