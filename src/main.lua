local connection = require('connection')
local jsonparser = require('parser')
local utf8 = require('lua-utf8')

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
	local tableWords = mysplit(content, " ,.\n")
	for k, v in pairs(tableWords) do
    print(k, v)
  end
end

local function printTable(table)
  for k, v in pairs(table) do
    print(k, v)
  end
end

local function getWordSize(words, size)
  local wordsInSize = {}
  for k, v in pairs(words) do
    if utf8.len(v) == size then
      table.insert(wordsInSize, v)
    end
  end
  return wordsInSize
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
		--print(content)
    if content ~= nil then
      tableWords = mysplit(content, " ,.\n")
    end
  end

	if menuOption == '2' then
		print('Qual o tamanho maximo da palavra?')
		wordLenght = io.read("*number")
		print("Pesquisando palavras...")
		selectWords = getWordSize(tableWords, wordLenght)
    printTable(selectWords)
	end
end
