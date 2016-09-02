package.path = package.path .. ';../src/?.lua'

local luaUnit = require('luaunit')
local conn = require('connection')

TestConn = {}

function TestConn:setUp()
	self.conn = conn
end

function TestConn:testConnection()
	result = self.conn.getPage()
	luaUnit.assertNotNil(result)
end

luaUnit.run('--verbose')
