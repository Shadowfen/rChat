test_run = {
}
require "rChat.test.tk"
require "rChat.test.zos"
require "LibSFUtils.LibSFUtils_Global"
require "LibSFUtils.LibSFUtils"
local TK = TestKit

TK.init()

local TR = test_run
local d = print

local SF = LibSFUtils

function TR.printTable(tbl)
    for k,v in pairs(tbl) do
        if type(v) == "table" then
            for kk, vv in pairs(v) do
                if type(vv) == "boolean" then
                    d("k="..k.." kk="..kk.." vv="..SF.bool2str(vv))
                else
                    d("k="..k.." kk="..kk.." vv="..vv)
                end
            end
        elseif type(v) == "boolean" then
            d("k="..k.." v="..SF.bool2str(v))
        elseif type(v) == "function" then
            d("k="..k.." v=function")
        else
            d("k="..k.." v="..v)
        end
    end
end


d("\n")

-- main
TK.init()

-- we are running subtests as part of a suite of tests
Suite = true

require "rChat.test.Format_Test"
Format_runTests()
d("\n--------------\n")

require "rChat.test.Data_Test"
Data_runTests()
d("\n--------------\n")

require "rChat.test.Mention_Test"
Mention_runTests()
d("\n--------------\n")

d("\n")
TK.showResult("testRChat")
