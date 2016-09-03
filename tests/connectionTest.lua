package.path = package.path .. ';../src/?.lua'

local luaUnit = require('luaunit')
local conn = require('connection')
local jsonparser = require('parser')

TestConn = {}

function TestConn:setUp()
	self.conn = conn:new()
	self.parser = jsonparser:new()
end

	function TestConn:testConnection()
		result = self.parser.parse(self.conn.getpage('Brasil'))
	print(result)
	luaUnit.assertNotNil(result)
end

luaUnit.run('--verbose')
