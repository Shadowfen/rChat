TestKit = {
  num_tests=0,
  pass = 0,
  fail = 0, 
  failT = {}
}

local TK = TestKit

TK.localization_strings = {
  UNKNOWN_STRING = "Unknown localization string",
  SUITE_RESULTS = " results:",
  TK_RESULTS = "TestKit results:",
  TESTS_RUN = "Number of tests run: ",
  PASS = "PASSED: ",
  FAIL = "FAILED: ",
  
}
local ls = TK.localization_strings

local function GetString(id)
  if( not id ) then
    return ls.UNKNOWN_STRING
  end
  return id
end

local function dbgt(tbl,...)
    local nargs = select('#',...)
    if not nargs or nargs < 1 then return end
    
    local i = 1
    for i=1, nargs do    -- for each parameter
        local argv= select(i,...)
        --tbl[#tbl+1] = tostring(argv)
        -- add string representation of argv to tbl
        if(argv == nil) then
            tbl[#tbl+1] = "(nil)"
        elseif type(argv) == "string" then
            tbl[#tbl+1] = argv
        elseif type(argv) == "table" then
            for k,v in pairs(argv) do
                tbl[#tbl+1] = dbg(k,"=",v)
            end
        else
            tbl[#tbl+1] = tostring(argv)
        end
    end
end

function dbg(...)
    local nargs = select('#',...)
    if not nargs or nargs < 1 then return end
    
    local tbl = {}
    dbgt(tbl,...)
    print(table.concat(tbl," "))
end


local lastfail
local function addFailure(tname)
    if lastfail ~= TK.fn then
        TK.failT[#TK.failT+1]="\n"..TK.fn.." :\r        "..tname
        lastfail = TK.fn
    else
        TK.failT[#TK.failT+1]="\r        "..tname
    end
end

function TK.printSuite(moduleName, fn)
    TK.fn = moduleName.."_"..fn
    print("\n"..moduleName.."_"..fn..":\n")
    lastfail = nil
end

function TK.init()
  TK.num_tests = 0
  TK.pass = 0
  TK.fail = 0
end

function TK.showResult(suitename)
  if( suitename ) then
    d(suitename..GetString(ls.SUITE_RESULTS))
  else
    d(GetString(ls.TK_RESULTS))
  end
  d(string.format("  %-25s %d",ls.TESTS_RUN, TK.num_tests))
  d(string.format("  %-25s %d",ls.PASS, TK.pass))
  d(string.format("  %-25s %d",ls.FAIL, TK.fail))
  
  if next(TK.failT) then
      d("\n\nNamed failing tests:")
      print("    "..table.concat(TK.failT,"    "))
  end
end
  
  

function TK.assertTrue(c, tname)
  TK.num_tests = TK.num_tests + 1
  if(c) then
    d(string.format("%-10s%s", ls.PASS, tname ))
    TK.pass = TK.pass + 1
  else
    d(string.format("%-10s%s", ls.FAIL, tname ))
    TK.fail = TK.fail + 1
    if tname then
        addFailure(tname)
    end
  end
end

function TK.assertFalse(c, tname)
  TK.num_tests = TK.num_tests + 1
  if(not c) then
    d(string.format("%-10s%s", ls.PASS,tname ))
    TK.pass = TK.pass + 1
  else
    d(string.format("%-10s%s", ls.FAIL,tname ))
    TK.fail = TK.fail + 1
    if tname then
        addFailure(tname)
    end
  end
end

function TK.assertNil(c, tname)
  TK.num_tests = TK.num_tests + 1
  if( c == nil ) then
    d(string.format("%-10s%s", ls.PASS,tname ))
    TK.pass = TK.pass + 1
  else
    d(string.format("%-10s%s", ls.FAIL,tname ))
    TK.fail = TK.fail + 1
    if tname then
        addFailure(tname)
    end
  end
end

function TK.assertNotNil(c, tname)
  TK.num_tests = TK.num_tests + 1
  if( c ~= nil ) then
    d(string.format("%-10s%s", ls.PASS,tname ))
    TK.pass = TK.pass + 1
  else
    d(string.format("%-10s%s", ls.FAIL,tname ))
    TK.fail = TK.fail + 1
    if tname then
        addFailure(tname)
    end
  end
end

function TK.listcount(tbl)
    local i = 0
    for k,v in pairs(tbl) do
        i = i + 1
    end
    return i
end

