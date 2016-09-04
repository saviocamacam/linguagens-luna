local https = require('ssl.https')

local connection = {}

local function getpage(about) 
	local url = ''
	if( about and about ~= '' ) then
		url ='https://pt.wikipedia.org/w/api.php?action=query&format=json&utf8=1&prop=extracts&explaintext=1&exsectionformat=plain&titles=' .. about 
	else
		url = 'https://pt.wikipedia.org/w/api.php?action=query&utf8=1&format=json&generator=random&grnnamespace=0&prop=extracts&explaintext=1&exsectionformat=plain'
	end
	return https.request(url)
end

local methods = { getpage = getpage }

local function new(o)
	newconn = o or {}
	setmetatable(newconn, { __index = methods })
	return newconn
end

return { new = new }
