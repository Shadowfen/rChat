rChat = rChat or {}

local SF = LibSFUtils

-- ------------------------------------------------------
-- Color conversion functions

-- Turn a ([0,1])^3 RGB colour to "|cABCDEF" form. We could use ZO_ColorDef, but we have so many colors so we don't do it.
function rChat.ConvertRGBToHex(r, g, b)
    return string.format("|c%.2x%.2x%.2x", zo_floor(r * 255), zo_floor(g * 255), zo_floor(b * 255))
end

-- Convert a colour from hexadecimal form to [0,1] RGB form.
function rChat.ConvertHexToRGBA(colourString)
    local r, g, b, a
    if string.sub(colourString,1,1) == "|" then
        -- format "|crrggbb"
        r=tonumber(string.sub(colourString, 3, 4), 16) or 255
        g=tonumber(string.sub(colourString, 5, 6), 16) or 255
        b=tonumber(string.sub(colourString, 7, 8), 16) or 255
        a = 255
    elseif #colourString == 8 then
        -- format "aarrggbb"
        a=tonumber(string.sub(colourString, 1, 2), 16) or 255
        r=tonumber(string.sub(colourString, 3, 4), 16) or 255
        g=tonumber(string.sub(colourString, 5, 6), 16) or 255
        b=tonumber(string.sub(colourString, 7, 8), 16) or 255
    elseif #colourString == 6 then
        -- format "rrggbb"
        r=tonumber(string.sub(colourString, 1, 2), 16) or 255
        g=tonumber(string.sub(colourString, 3, 4), 16) or 255
        b=tonumber(string.sub(colourString, 5, 6), 16) or 255
        a = 255
    else
        -- unidentified format
        r = 255
        g = 255
        b = 255
        a = 255
    end
    return r/255, g/255, b/255, a/255
end

-- Convert a colour from "|cABCDEF" form to [0,1] RGB form and return them in a table.
function rChat.ConvertHexToRGBAPacked(colourString)
    local r, g, b, a = rChat.ConvertHexToRGBA(colourString)
    return {r = r, g = g, b = b, a = a}
end
