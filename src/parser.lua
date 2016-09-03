local jsonparser = require('lunajson')
local conn = require('connection')

local parser = {}

local function parse(text)
	local res = jsonparser.decode(text)
	for k,v in pairs(res.query.pages) do
		return v.extract
	end
	return nil
end

local methods = { parse = parse }

local function new(o)
	newparser = o or {  }
	setmetatable(newparser, { __index = methods })
	return newparser
end

return { new = new }

