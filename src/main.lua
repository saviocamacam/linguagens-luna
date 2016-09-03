local connection = require('connection')
local jsonparser = require('parser')

parser = jsonparser:new()
conn = connection:new()

while menuOption ~= '6' do
	print('LunaLetroca')
	print('[1]: Pesquisar novo tema')
	print('[6]: Sair')
	menuOption = io.read()

	if menuOption == '1' then
		io.write("Digite um tema a ser pesquisado: ")
		theme = string.format("%s", io.read())
		print("Fazendo a requisição no Wikipedia...")
		json = conn.getpage(theme)
		print("Fazendo parsing...")
		content = parser.parse(json)
		print(content)
	end
end
