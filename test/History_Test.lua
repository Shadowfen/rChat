require "rChat.test.tk"
require "rChat.test.zos"
require "LibSFUtils.LibSFUtils_Global"
require "LibSFUtils.SFUtils_Color"
require "LibSFUtils.SFUtils_Events"
require "LibSFUtils.LibSFUtils"
require "LibSFUtils.SFUtils_VersionChecker"
require "LibSFUtils.SFUtils_LoadLanguage"
require "LibSFUtils.SFUtils_Logger"
require "LibSFUtils.SFUtils_Tables"
require "LibSFUtils.SFUtils_Guild"
require "rChat.rChat_Global"
require "rChat.rChatData.rChatData"

local TK = TestKit
local SF = LibSFUtils

local TR = test_run
local d = print

local moduleName = "rChat"
local mn = "rChat"

SF.EvtMgr.evtnames = {}


---------------------------------
-- utility functions
local function populateNewCache()
    rChatData.cache = {Entries={}}    
    rChatData.initCache()
    -- first entry
    rChatData.SetLine({
        timestamp = 1234,    --[1]
        channel = 7,      --[2]   the channel that the message was on
        from = "@Bob",         --[3]   the sender of the message (not really raw)
        message = "This is a test",      --[4]   the text of the message
        line = "[11:56] @Bob: This is a test",         --[5]   includes timestamp, from, channel, message, etc
        rawDisplayed = "[11:56] |cffffff@Bob|r: This is a test", --[6]   what actually gets printed to the chat window
        rawValue = "",
        ndx = 1,
        })
    -- second entry
    rChatData.SetLine({
        timestamp = 1235,    --[1]
        channel = 6,      --[2]   the channel that the message was on
        from = "@Bobbie",         --[3]   the sender of the message (not really raw)
        message = "This not is a test",      --[4]   the text of the message
        line = "[11:57] @Bobbie: This not is a test",         --[5]   includes timestamp, from, channel, message, etc
        rawDisplayed = "[11:57] |cffffff@Bobbie|r: This not is a test", --[6]   what actually gets printed to the chat window
        rawValue = "",
        ndx = 2,
    })
    -- third entry
    rChatData.SetLine({
        timestamp = 1236,    --[1]
        channel = 5,      --[2]   the channel that the message was on
        from = "@Adam",         --[3]   the sender of the message (not really raw)
        message = "Help!",      --[4]   the text of the message
        line = "[11:58] @Adam: Help!",         --[5]   includes timestamp, from, channel, message, etc
        rawDisplayed = "[11:58] |cffffff@Adam|r: Help!", --[6]   what actually gets printed to the chat window
        rawValue = "",
        ndx = 3,
    })
end

---------------------------------
-- test functions

local function Cache_testInitCache()
    local fn = "testInitCache"
    TK.printSuite(mn,fn)
    rChatData.cache = { Entries = {}, }
    rChatData.initCache(30)
    TK.assertNotNil(rChatData.cache.Entries,"Initializing Entries")
    TK.assertNotNil(rChatData.cache.lineNumber,"Initializing lineNumber")
    TK.assertTrue(rChatData.cache.lineNumber == 1, "lineNumber == 1")
end


local function Cache_testSetLine()
    local fn = "testSetLine"
    TK.printSuite(mn,fn)
    rChatData.cache = nil
    rChatData.initCache(30)
    
    do 
        local fn = "  SetLine - test_FirstCacheEntry"
        TK.printSuite(mn,fn)
        rChatData.SetLine({
            timestamp = 1234,    --[1]
            channel = 7,      --[2]   the channel that the message was on
            from = "@Bob",         --[3]   the sender of the message (not really raw)
            message = "This is a test",      --[4]   the text of the message
            line = "[11:56] @Bob: This is a test",         --[5]   includes timestamp, from, channel, message, etc
            rawDisplayed = "[11:56] |cffffff@Bob|r: This is a test", --[6]   what actually gets printed to the chat window
            rawValue = "",
        })
        TK.assertTrue(rChatData.cache.lineNumber == 1, "Has first cache entry")
        TK.assertTrue(rChatData.getChatCacheSize() == 1, "has first cache entry")
        --local entry = rChatData.cache.Entries[1]
        local entry =  rChatData.getCacheEntry(1)
        TK.assertNotNil(entry, "Retrieved first cache entry")
        --d(entry.timestamp)
        TK.assertTrue(entry.timestamp == 1234, "First cache entry has correct timestamp")
    end
    
    do
        local fn = "  SetLine - test_SecondCacheEntry"
        TK.printSuite(mn,fn)
        rChatData.SetLine({
            timestamp = 1235,    --[1]
            channel = 6,      --[2]   the channel that the message was on
            from = "@Bobbie",         --[3]   the sender of the message (not really raw)
            message = "This not is a test",      --[4]   the text of the message
            line = "[11:57] @Bobbie: This not is a test",         --[5]   includes timestamp, from, channel, message, etc
            rawDisplayed = "[11:57] |cffffff@Bobbie|r: This not is a test", --[6]   what actually gets printed to the chat window
            rawValue = "",
        })
        TK.assertTrue(rChatData.cache.lineNumber == 1, "Has additional cache entry "..rChatData.cache.lineNumber)
        TK.assertTrue(rChatData.getChatCacheSize() == 2, "has additional cache entry")
        entry =  rChatData.getCacheEntry(2)
        TK.assertNotNil(entry, "Retrieved second cache entry")
        TK.assertTrue(entry.timestamp == 1235, "Second cache entry has correct timestamp")
    end
    
    do
        local fn = "  test_ReplaceFirstCacheEntry"
        TK.printSuite(mn,fn)
        rChatData.SetLine(1, {
            timestamp = 1236,    --[1]
            channel = 6,      --[2]   the channel that the message was on
            from = "@Adam",         --[3]   the sender of the message (not really raw)
            message = "Help!",      --[4]   the text of the message
            line = "[11:58] @Adam: Help!",         --[5]   includes timestamp, from, channel, message, etc
            rawDisplayed = "[11:58] |cffffff@Adam|r: Help!", --[6]   what actually gets printed to the chat window
            rawValue = "",
        } )
        TK.assertTrue(rChatData.cache.lineNumber == 1, "Number of cache entries unchanged")
        TK.assertTrue(rChatData.getChatCacheSize() == 2, "number of cache entries unchanged")
        entry =  rChatData.getCacheEntry(1)
        TK.assertNotNil(entry, "Retrieved new first cache entry")
        TK.assertTrue(entry.timestamp == 1236, "New first cache entry has correct timestamp")
        TK.assertTrue(entry.from == "@Adam", "New first cache entry has correct from")
    end
end


local function Cache_testGetLine()
    local fn = "testGetLine"
    TK.printSuite(mn,fn)
    rChatData.cache = nil
    populateNewCache()
    
    do
        local fn = "  testGetLine_2nd"
        TK.printSuite(mn,fn)
        local entry, ndx = rChatData.getCacheEntry(2)  -- "real" last line is always empty - lineNumber == 4 here
        --d(SF.dstr(" ", entry))
        TK.assertTrue(ndx == 2, "Entry index is 2")
        TK.assertTrue(entry.from == "@Bobbie", "Entry from is @@Bobbie")
    end
    do
        local fn = "  testGetLine_1t"
        TK.printSuite(mn,fn)
        local entry, ndx = rChatData.getCacheEntry(1)
        --d(SF.dstr(" ", entry))
        TK.assertTrue(ndx == 1, "Entry index is 1")
        TK.assertTrue(entry.from == "@Adam", "Entry from is @Adam")
    end
    do
        local fn = "  testGetLine_5th"
        TK.printSuite(mn,fn)
        local entry, ndx = rChatData.getCacheEntry(5)
        --d(SF.dstr(" ", entry))
        --d("Entry index is="..tostring(ndx))
        TK.assertTrue(ndx == 5, "Entry index is 5")
        TK.assertNotNil(entry, "Entry is not nil")
    end
end


local function Cache_testIterCache()
    local fn = "testIterCache"
    TK.printSuite(mn,fn)
    rChatData.cache = nil
    populateNewCache()
    
    local froms = {
        [1] = {1234,"@Bob"},
        [2] = {1235,"@Bobbie"},
        [3] = {1236,"@Adam"},
    }
    for ndx, entry in pairs(rChatData.cache.Entries) do
        if not entry or ndx <= 0 then break end
        TK.assertNotNil(entry, "retrieved entry "..ndx)
        --d(SF.dstr1(" ",entry, ndx))
        --local ndx = 1
        TK.assertNotNil(entry.timestamp, "timestamp is not nil "..tostring(entry.timestamp))
        TK.assertNotNil(froms[ndx][1], "froms is not nil "..tostring(froms[ndx][1]))
        TK.assertTrue(entry.timestamp == froms[ndx][1], "timestamp is correct")
        TK.assertTrue(entry.timestamp == froms[ndx][1], "timestamp is correct")
        TK.assertTrue(entry.timestamp == froms[ndx][1], "timestamp is correct")
        TK.assertTrue(entry.from == froms[ndx][2], "from is correct")
    end
end


local function Cache_testClearCache()
    local fn = "testClearCache"
    TK.printSuite(mn,fn)
    populateNewCache()

    rChatData.clearCache()
    TK.assertTrue(type(rChatData.cache.Entries) == "table","Valid LineStrings table")
    TK.assertNil(next(rChatData.cache.Entries), "Table is empty")
    TK.assertTrue(rChatData.cache.lineNumber == 1, "lineNumber == 1")
end



function History_runTests()
    Cache_testInitCache()
    Cache_testSetLine()
    Cache_testGetLine()
    Cache_testIterCache()
    Cache_testClearCache()
end


-- main
if not Suite then
    History_runTests()
    d("\n")
    TK.showResult("History_Test")
end
