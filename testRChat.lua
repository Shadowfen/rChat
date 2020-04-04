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



require "rChat.test.History_Test"
History_runTests()

d("\n")
TK.showResult()
