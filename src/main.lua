local connection = require('connection')
local jsonparser = require('parser')

parser = jsonparser:new()
conn = connection:new()

function mysplit(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
    i = i + 1
	end
	return t
end

local function searchWords(content, wordLenght)
	local tableWords = mysplit(content, " ")
	print(tableWords)
end

while menuOption ~= '6' do
	print('LunaLetroca')
	print('[1]: Pesquisar novo tema')
	print('[2]: Informar tamanho da palavra')
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

	if menuOption == '2' then
		print('Qual o tamanho maximo da palavra?')
		wordLenght = io.read()


		print("Pesquisando palavras...")

		selectWords = searchWords(content, wordLenght)
	end
end
