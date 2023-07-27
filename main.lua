local Base1114111 = {}

utf8_byte = function(s)
    local bytes = {}

    string.gsub(s, "([%z\1-\127\194-\244][\128-\191]*)", function(c)
        local byte

        for i = 1, #c do
            local c = string.byte(c, i)

            byte = (i == 1) and bit32.band(c, (2 ^ (8 - (c < 0x80 and 1 or c < 0xE0 and 2 or c < 0xF0 and 3 or c < 0xF8 and 4 or c < 0xFC and 5 or c < 0xFE and 6)) - 1)) or (bit32.lshift(byte, 6) + bit32.band(c, 0x3F))
        end
    
        table.insert(bytes, byte)
    end)

    return table.unpack(bytes)
end

Base1114111.Encode = function(Number)
	local Encoded = {}
	
	while Number > 0 do
		table.insert(Encoded, 1, (Number % 1114110))
		
	    Number = math.floor(Number / 1114110)
	end
	
	return utf8.char(table.unpack(Encoded))
end

Base1114111.Decode = function(String)
	local Table = {utf8_byte(String)}
	
	local Decoded = 0
	for Index = 1, #Table do
		Decoded = Decoded + Table[#Table - Index + 1] * 1114110 ^ (Index - 1) 
	end
	
	return Decoded
end

local Base256 = {}

Base256.Encode = function(Number)
	local Encoded = {}
	
	while Number > 0 do
		table.insert(Encoded, 1, (Number % 256))
		
	    Number = math.floor(Number / 256)
	end
	
	return string.char(table.unpack(Encoded))
end

local Base65536 = {}

Base65536.Encode = function(String)
	return string.gsub(String, "..?", function(c)
		local a, b = string.byte(c, 1, -1)
		
		return Base1114111.Encode(a * (b and 256 or 1) + (b or 0))
	end)
end

Base65536.Decode = function(Encoded)
	return string.gsub(Encoded, "([%z\1-\127\194-\244][\128-\191]*)", function(c)
		return Base256.Encode(Base1114111.Decode(c))
	end)
end

return Base65536
