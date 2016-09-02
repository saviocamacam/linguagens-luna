local http = require('socket.http')


local conexao = {}

function getPage(about) 
	if (about == nil ) then
		about = 'Especial:Aleatória'
	end
	url = 'https://pt.wikipedia.org/wiki/' .. about 
	return http.request(url)
end

return conexao
