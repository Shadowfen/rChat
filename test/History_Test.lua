require "rChat.test.tk"
require "rChat.test.zos"
require "LibSFUtils.LibSFUtils_Global"
require "LibSFUtils.LibSFUtils"
require "LibSFUtils.SFUtils_VersionChecker"
require "LibSFUtils.SFUtils_LoadLanguage"
require "rChat.rChat_Global"
require "rChat.rChat_History"
local TK = TestKit
local SF = LibSFUtils

local TR = test_run
local d = print

local moduleName = "rChat"
local mn = "rChat"


---------------------------------
-- utility functions
local function populateNewCache()
    rChat.save = {}    
    rChat.initCache()
    -- first entry
    rChat.SetLine({
        timestamp = 1234,    --[1]
        channel = 7,      --[2]   the channel that the message was on
        from = "@Bob",         --[3]   the sender of the message (not really raw)
        message = "This is a test",      --[4]   the text of the message
        line = "[11:56] @Bob: This is a test",         --[5]   includes timestamp, from, channel, message, etc
        rawDisplayed = "[11:56] |cffffff@Bob|r: This is a test", --[6]   what actually gets printed to the chat window
        rawValue = "",
        })
    -- second entry
    rChat.SetLine({
        timestamp = 1235,    --[1]
        channel = 6,      --[2]   the channel that the message was on
        from = "@Bobbie",         --[3]   the sender of the message (not really raw)
        message = "This not is a test",      --[4]   the text of the message
        line = "[11:57] @Bobbie: This not is a test",         --[5]   includes timestamp, from, channel, message, etc
        rawDisplayed = "[11:57] |cffffff@Bobbie|r: This not is a test", --[6]   what actually gets printed to the chat window
        rawValue = "",
    })
    -- third entry
    rChat.SetLine({
        timestamp = 1236,    --[1]
        channel = 5,      --[2]   the channel that the message was on
        from = "@Adam",         --[3]   the sender of the message (not really raw)
        message = "Help!",      --[4]   the text of the message
        line = "[11:58] @Adam: Help!",         --[5]   includes timestamp, from, channel, message, etc
        rawDisplayed = "[11:58] |cffffff@Adam|r: Help!", --[6]   what actually gets printed to the chat window
        rawValue = "",
    })
end

---------------------------------
-- test functions

local function Cache_testInitCache()
    local fn = "testInitCache"
    TK.printSuite(mn,fn)
    rChat.save = {}
    
    rChat.initCache()
    TK.assertNotNil(rChat.save.LineStrings,"Initializing LineStrings")
    TK.assertNotNil(rChat.save.lineNumber,"Initializing lineNumber")
    TK.assertTrue(rChat.save.lineNumber == 1, "lineNumber == 1")
end

local function Cache_testSetLine()
    local fn = "testInitCache"
    TK.printSuite(mn,fn)
    rChat.save = {}
    rChat.initCache()
    
    do 
        local fn = "  test_FirstCacheEntry"
        TK.printSuite(mn,fn)
        rChat.SetLine({
            timestamp = 1234,    --[1]
            channel = 7,      --[2]   the channel that the message was on
            from = "@Bob",         --[3]   the sender of the message (not really raw)
            message = "This is a test",      --[4]   the text of the message
            line = "[11:56] @Bob: This is a test",         --[5]   includes timestamp, from, channel, message, etc
            rawDisplayed = "[11:56] |cffffff@Bob|r: This is a test", --[6]   what actually gets printed to the chat window
            rawValue = "",
        })
        TK.assertTrue(rChat.save.lineNumber == 2, "Has first cache entry")
        local entry = rChat.save.LineStrings[1]
        TK.assertNotNil(entry, "Retrieved first cache entry")
        d(entry.timestamp)
        TK.assertTrue(entry.timestamp == 1234, "First cache entry has correct timestamp")
    end
    
    do
        local fn = "  test_SecondCacheEntry"
        TK.printSuite(mn,fn)
        rChat.SetLine({
            timestamp = 1235,    --[1]
            channel = 6,      --[2]   the channel that the message was on
            from = "@Bobbie",         --[3]   the sender of the message (not really raw)
            message = "This not is a test",      --[4]   the text of the message
            line = "[11:57] @Bobbie: This not is a test",         --[5]   includes timestamp, from, channel, message, etc
            rawDisplayed = "[11:57] |cffffff@Bobbie|r: This not is a test", --[6]   what actually gets printed to the chat window
            rawValue = "",
        })
        TK.assertTrue(rChat.save.lineNumber == 3, "Has additional cache entry")
        entry = rChat.save.LineStrings[2]
        TK.assertNotNil(entry, "Retrieved second cache entry")
        TK.assertTrue(entry.timestamp == 1235, "Second cache entry has correct timestamp")
    end
    
    do
        local fn = "  test_ReplaceFirstCacheEntry"
        TK.printSuite(mn,fn)
        rChat.SetLine({
            timestamp = 1236,    --[1]
            channel = 6,      --[2]   the channel that the message was on
            from = "@Adam",         --[3]   the sender of the message (not really raw)
            message = "Help!",      --[4]   the text of the message
            line = "[11:58] @Adam: Help!",         --[5]   includes timestamp, from, channel, message, etc
            rawDisplayed = "[11:58] |cffffff@Adam|r: Help!", --[6]   what actually gets printed to the chat window
            rawValue = "",
        }, 1)
        TK.assertTrue(rChat.save.lineNumber == 3, "Number of cache entries unchanged")
        entry = rChat.save.LineStrings[1]
        TK.assertNotNil(entry, "Retrieved new first cache entry")
        TK.assertTrue(entry.timestamp == 1236, "New first cache entry has correct timestamp")
        TK.assertTrue(entry.from == "@Adam", "New first cache entry has correct from")
    end
end

local function Cache_testGetLine()
    local fn = "testInitCache"
    TK.printSuite(mn,fn)
    populateNewCache()
    
    do
        local fn = "  testGetLine_last"
        TK.printSuite(mn,fn)
        local entry, ndx = rChat.GetLine(3)  -- "real" last line is always empty - lineNumber == 4 here
        TK.assertTrue(ndx == 3, "Entry index is 3")
        TK.assertTrue(entry.from == "@Adam", "Entry from is @Adam")
    end
    do
        local fn = "  testGetLine_first"
        TK.printSuite(mn,fn)
        local entry, ndx = rChat.GetLine(1)
        TK.assertTrue(ndx == 1, "Entry index is 1")
        TK.assertTrue(entry.from == "@Bob", "Entry from is @Bob")
    end
    do
        local fn = "  testGetLine_5th"
        TK.printSuite(mn,fn)
        local entry, ndx = rChat.GetLine(5)
        TK.assertTrue(ndx == 0, "Entry index is 0")
        TK.assertNil(entry, "No such entry")
    end
end

local function Cache_testIterCache()
    local fn = "testIterCache"
    TK.printSuite(mn,fn)
    populateNewCache()
    
    local froms = {
        [1] = {1234,"@Bob"},
        [2] = {1235,"@Bobbie"},
        [3] = {1236,"@Adam"},
    }
    for ndx, entry in rChat.iterCache() do
        TK.assertNotNil(entry, "retrieved entry "..ndx)
        TK.assertTrue(entry.timestamp == froms[ndx][1], "timestamp is correct")
        TK.assertTrue(entry.from == froms[ndx][2], "from is correct")
    end
end

local function Cache_testClearCache()
    local fn = "testClearCache"
    TK.printSuite(mn,fn)
    populateNewCache()
    
    rChat.clearCache()
    TK.assertTrue(type(rChat.save.LineStrings) == "table","Valid LineStrings table")
    TK.assertNil(next(rChat.save.LineStrings), "Table is empty")
    TK.assertTrue(rChat.save.lineNumber == 1, "lineNumber == 1")
end

function History_runTests()
    Cache_testInitCache()
    Cache_testSetLine()
    Cache_testGetLine()
    Cache_testIterCache()
    Cache_testClearCache()
end

