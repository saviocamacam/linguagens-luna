local https = require('ssl.https')

local connection = {}

function connection.getPage(about) 
	about = about or 'Especial:Aleatória'
	
	url = 'https://pt.wikipedia.org/wiki/' .. about 
	return https.request(url)
end

return connection
