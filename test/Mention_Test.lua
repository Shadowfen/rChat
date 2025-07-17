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

local mn = "Mention"

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
-- copies of functions from rChat.lua (because they are local)

-- ---------------------------------------------------------------
-- Mention functions
--   functions manipulating a mention table is a list of tables (one per entry) containing
--   [1] = the entry to search for, [2] = the colorized version of the entry


-- combine entries of a mention table into a string for an editbox
local function mention_combine(tbl)
    local str
    if tbl then
        for _,v in ipairs(tbl) do
            if not str then
                str = v[1]
            else
                str = string.format("%s\r\n%s",str, v[1])
            end
        end
    else
        str = ""
    end
    return str
end

-- split a mention string (one entry per line) into appropriate entries
-- in the mention table
-- returns the mention table
local function mention_split(newValue, col) 
    lines = {}
    for s in newValue:gmatch("[^\r\n]+") do
        table.insert(lines, s)
    end
    newtbl = {}
    for _,v in ipairs(lines) do
        -- require minimum length
        if string.len(v) >= 4 then
            if nil == string.find(v, "[%%%*%-%.%+%(%)%[%]%^%$%?]") then
                -- have no regex pattern characters
                local c = v -- in case we don't have a color passed in
                if col then
                    c = string.format("%s%s|r", col,v)
                end
                newtbl[#newtbl+1]={v,c}
                --table.insert(newtbl,{v,c})
            end
        end
    end
    return newtbl
end

-- changes the colorized versions of mention to use the
-- new color
local function mention_recolor(mentiontbl, newcolor)
    if mentiontbl then
        for _,v in ipairs(mentiontbl) do
            if not newcolor then 
                v[2] = v[1]     -- should I nil this?
            else
                v[2] = string.format("%s%s|r", newcolor,v[1])
            end
        end
    end
    return mentiontbl
end

---------------------------------
-- test functions


local function Mention_testSplit()
    local fn = "testSplit"
    TK.printSuite(mn,fn)
    
    local str = "qwea\n\r\nasdb\rzxce"
    local lines = mention_split(str)
    TK.assertTrue(lines[1][1] == "qwea", "got first mention")
    TK.assertTrue(lines[2][1] == "asdb", "got second mention")
    TK.assertTrue(lines[3][1] == "zxce", "got third mention")
end

local function Mention_testSplit_uncolored()
    local fn = "testSplit_uncolored"
    TK.printSuite(mn,fn)
    
    local str = "qwea\n\r\nasdb\rzxce"
    local lines = mention_split(str)
    TK.assertTrue(lines[1][2] == "qwea", "got uncolored first mention")
    TK.assertTrue(lines[2][2] == "asdb", "got uncolored second mention")
    TK.assertTrue(lines[3][2] == "zxce", "got uncolored third mention")
end

local function Mention_testSplit_colored()
    local fn = "testSplit_colored"
    TK.printSuite(mn,fn)
    
    local str = "qwea\n\r\nasdb\rzxce"
    local lines = mention_split(str, "|cFFAAAA")
    TK.assertTrue(lines[1][2] == "|cFFAAAAqwea|r", "got colored first mention")
    TK.assertTrue(lines[2][2] == "|cFFAAAAasdb|r", "got colored second mention")
    TK.assertTrue(lines[3][2] == "|cFFAAAAzxce|r", "got colored third mention")
end

local function Mention_testSet()
    local fn = "testSet"
    TK.printSuite(mn,fn)
    
    
    local fn1 = "testSet_singleline"
    TK.printSuite(mn,fn1)
    local tbl1 = mention_split("singleline")
    TK.assertNotNil(tbl1,"got table1")
    TK.assertTrue(#tbl1 == 1, "singleline has 1 entry")
    TK.assertTrue(tbl1[1][1] == "singleline","has first value")
    TK.assertTrue(tbl1[1][2] == "singleline", "has second value")    -- no color

    local fn2 = "testSet_doubleline"
    TK.printSuite(mn,fn2)
    local tbl2 = mention_split("doubleline1\ndoubleline2")
    TK.assertNotNil(tbl2,"got table2")
    TK.assertTrue(#tbl2 == 2, "doubleline has 2 entries")
    TK.assertTrue(tbl2[1][1] == "doubleline1","1. has first value")
    TK.assertTrue(tbl2[1][2] == "doubleline1", "1. has second value")    -- no color
    TK.assertTrue(tbl2[2][1] == "doubleline2", "2. has first value")
    TK.assertTrue(tbl2[2][2] == "doubleline2", "2. has second value")    -- no color

    local fn3 = "testSet_colorline"
    TK.printSuite(mn,fn3)
    local tbl3 = mention_split("colorline","|cFFFFFF")
    TK.assertNotNil(tbl3,"got table3")
    TK.assertTrue(#tbl3 == 1, "colorline has 1 entry")
    TK.assertTrue(tbl3[1][1] == "colorline", "has first value")
    TK.assertTrue(tbl3[1][2] == "|cFFFFFFcolorline|r", "has colorized value")

end

local function Mention_testCombine()
    local mentiontbl = {
            [1] = { [1] = "guild", [2] = "|cFFFFFFguild|r", },
            [2] = { [1] = "tank", [2] = "|cFFFFFFtank|r", },
            [3] = { [1] = "world", [2] = "|cFFFFFFworld||r", },
        }
    local valstr = "guild\r\ntank\r\nworld"
    TK.assertTrue(mention_combine(mentiontbl) == valstr, valstr)
    TK.assertTrue(mention_combine(nil) == "" ,"nil")
    TK.assertTrue(mention_combine({{"overland","overland"}}) == "overland", "overland")
    
end

local function Mention_testGet()
    local mention = {
        ["mentiontbl"] = {
            { "guild", "guild"},
        }
    }
    
    TK.assertTrue(mention_combine(mention.mentiontbl) == "guild","single entry")
    mention.mentiontbl[2] = { "tank", "tank" }
    TK.assertTrue(mention_combine(mention.mentiontbl) == "guild\r\ntank","double entry")
end

local function Mention_testRecolor()
    local mentiontbl = {
            [1] = { [1] = "guild", [2] = "|cFFFFFFguild|r", },
            [2] = { [1] = "tank", [2] = "|cFFFFFFtank|r", },
            [3] = { [1] = "world", [2] = "|cFFFFFFworld||r", },
        }
    local color = "|cFFAAAA"
    mention_recolor(mentiontbl,color)
    for _,v in ipairs(mentiontbl) do
        TK.assertTrue(v[2] == string.format("%s%s|r",color,v[1]), "color changed for entry "..v[1].."  "..v[2] )
    end
end

function Mention_runTests()
    rChatData.initCache()
    Mention_testSplit()
    Mention_testSplit_uncolored()
    Mention_testSplit_colored()
    Mention_testSet()
    Mention_testCombine()
    Mention_testGet()
    Mention_testRecolor()
    rChatData.clearCache()
end

-- main
if not Suite then
    Mention_runTests()
    d("\n")
    TK.showResult("Mention_Test")
end
