local connection = require('connection')
local jsonparser = require('parser')
local newUtf8 = require('lua-utf8')

parser = jsonparser:new()
conn = connection:new()

function mysplit(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^%p%s]+)") do
		t[i] = str
    i = i + 1
	end
	return t
end

local function searchWords(content, wordLenght)
	local allWords = mysplit(content, "%p+%s")
	for k, v in pairs(allWords) do
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

local function notInTable(selectedWords, wordIn)
  for k, v in pairs(selectedWords) do
    if v == wordIn then
      return false
    end
  end
  return true
end

local function inTableIndex(selectedWords, wordIn)
  for k, v in pairs(selectedWords) do
    if v == wordIn then
      return k
    end
  end
  return -1
end

local function letterInWord(mainWord, char, bool, tableLetters)
  if bool then
    printTable(tableLetters)
  end

  for c in newUtf8.gmatch(mainWord, ".") do
    if c == char and tableLetters[c] > 0 then
      tableLetters[c] = tableLetters[c] - 1
      return true
    end
  end
  return false
end

local function selectWords(allWords, wordLenght)
  local wordsLengthN = getWordSize(allWords, wordLenght)
  local position = math.random(#wordsLengthN)
  local mainWord = wordsLengthN[position]
  local wordsInZeroToWordLenght = {}
  local selectedWords = {}

  for k, v in pairs(allWords) do
    if utf8.len(v) <= wordLenght then
      table.insert(wordsInZeroToWordLenght, v)
    end
  end

  local counter = 0
  for k, v in pairs(wordsInZeroToWordLenght) do

    local tableLetters = {}
    for c in newUtf8.gmatch(mainWord, ".") do
      if not tableLetters[c] then
        tableLetters[c] = 1
      else
        tableLetters[c] = tableLetters[c] + 1
      end
    end

    for c in newUtf8.gmatch(v, ".") do

      local boolean = letterInWord(mainWord, c, bool, tableLetters)
      if boolean then
        counter = counter + 1
      end
    end

    if counter == utf8.len(v) and notInTable(selectedWords, v) then
      table.insert(selectedWords, v)
    end
    counter = 0
  end

  --printTable(selectedWords)
  print("Principal: ", position, mainWord)
  return selectedWords, mainWord
end

function createMask(selectedWords)
  local wordMask = {}
  local a = ""
  local biggest = ""
  local biggestTable = {}
  for k, v in pairs(selectedWords) do
    for c in newUtf8.gmatch(v, ".") do
      a = a .."_ "
    end
    if utf8.len(a) > utf8.len(biggest) then
      biggest = a
      biggestTable = {}
      for c in newUtf8.gmatch(a, ".") do
        table.insert(biggestTable, c)
      end
    end
    table.insert(wordMask, a)
    a = ""
  end
  return wordMask, biggestTable
end

function shuffleWord(mainWord)
  local mainWordTable = {}
  local squigglyWordTable = {}
  local tablePositions = {}
  for c in newUtf8.gmatch(mainWord, ".") do
    table.insert(mainWordTable, c)
  end

  local i = 1
  while i ~= #mainWordTable+1 do
    local position = math.random(#mainWordTable)
    local letter = mainWordTable[position]
    if notInTable(tablePositions, position) then
      table.insert(tablePositions, position)
      table.insert(squigglyWordTable, letter)
      i = i + 1
    end
  end

  return squigglyWordTable
end

function tableToString(squigglyWordTable, bool)
  local squigglyWord = ""
  for k, v in pairs(squigglyWordTable) do
    if bool then
      squigglyWord = squigglyWord .. v .." "
    end
    if v ~= '_' and v ~= ' ' and not bool then
      squigglyWord = squigglyWord .. v
    end
  end
  return squigglyWord
end

function showMenu()
  print('LunaLetroca')
	print('[1]: Pesquisar novo tema')
	print('[2]: Informar tamanho da palavra')
  print('[3]: Embaralhar letras')
	print('[6]: Sair')
end

function printMask(wordMask, squigglyWord, biggestMask)
  printTable(wordMask)
  print("\nSquiggly Word: ", squigglyWord)
  print("\nMascara: ", biggestMask)
end

function insertLetter(biggestMaskTable, newLetter)
  for k, v in pairs(biggestMaskTable) do
    if v == '_' then
      biggestMaskTable[k] = newLetter
      return
    end
  end
end

function removeLetter(squigglyWordTable, newLetter)
  for k, v in pairs(squigglyWordTable) do
    if v == newLetter then
      table.remove(squigglyWordTable, k)
      return
    end
  end
end

function resetBiggestMask(wordMaskTable)
  for k, v in pairs(wordMaskTable) do
    if v ~= ' ' and v ~= '_' then
      wordMaskTable[k] = '_'
    end
  end
end

function pop(wordMaskTable)
  for k, v in pairs(wordMaskTable) do
    if v == '_' and k > 2 then
      local letter = wordMaskTable[k-2]
      wordMaskTable[k-2] = '_'
      return letter
    end
    if k == #wordMaskTable then
      local letter = wordMaskTable[k-1]
      wordMaskTable[k-1] = '_'
      return letter
    end
  end
end

function pull(squigglyWordTable, letter)
  table.insert(squigglyWordTable, letter)
end

showMenu()
menuOption = io.read()

while menuOption ~= '6' do

	if menuOption == '1' then
		io.write("Digite um tema a ser pesquisado: ")
		tema = string.format("%s", io.read())
		print("Fazendo a requisição no Wikipedia...")
		json = conn.getpage(tema)
		print("Fazendo parsing...")
		content = parser.parse(json)
		--print(content)
    if content ~= nil then
      allWords = mysplit(content, " ,.\n")
    end
  end

	if menuOption == '2' then
		print('Qual o tamanho maximo da palavra?')
		wordLenght = io.read("*number")
		print("Pesquisando palavras...")

    selectedWords, mainWord = selectWords(allWords, wordLenght)
    printTable(selectedWords)
    wordMask, biggestMaskTable = createMask(selectedWords)

    squigglyWordTable = shuffleWord(mainWord)
    squigglyWord = tableToString(squigglyWordTable, true)

    --menuOption = '3'
	end

  if menuOption == '3' then

    squigglyWordTable = shuffleWord(mainWord)
    squigglyWord = tableToString(squigglyWordTable, true)
    biggestMask = tableToString(biggestMaskTable, true)
    printMask(wordMask, squigglyWord, biggestMask)
    io.write("Nova entrada: ")
    local newLetter = io.read()

    while newLetter ~= '1' and newLetter ~= '2' and newLetter ~= '3' do
      if not notInTable(squigglyWordTable, newLetter) then
        print("tem: ", newLetter)

        insertLetter(biggestMaskTable, newLetter)
        removeLetter(squigglyWordTable, newLetter)
        squigglyWord = tableToString(squigglyWordTable, true)
        biggestMask = tableToString(biggestMaskTable, true)
        printMask(wordMask, squigglyWord, biggestMask)

      else
        print("nao tem: ", newLetter)
      end
      io.write("Testar? >> ! : ")
      io.write("Nova entrada: ")
      newLetter = io.read()

      if newLetter == '!' then
        wordForTest = tableToString(biggestMaskTable, false)
        print("For test: ", wordForTest)
        indexOfWord = inTableIndex(selectedWords, wordForTest)

        if indexOfWord > 0 then
          print("Essa palavra existe!")
          wordMask[indexOfWord] = wordForTest
          resetBiggestMask(biggestMaskTable)

          squigglyWordTable = shuffleWord(mainWord)
          squigglyWord = tableToString(squigglyWordTable, true)
          biggestMask = tableToString(biggestMaskTable, true)
          printMask(wordMask, squigglyWord, biggestMask)
          io.write("Nova entrada: ")
          newLetter = io.read()

        else
          print("Essa palavra nao existe aqui!")
          printMask(wordMask, squigglyWord, biggestMask)
          io.write("Nova entrada: ")
          newLetter = io.read()
        end
      end

      if newLetter == '*' then
        letterP = pop(biggestMaskTable)
        print("l: ", letterP)
        pull(squigglyWordTable, letterP)
        squigglyWord = tableToString(squigglyWordTable, true)
        biggestMask = tableToString(biggestMaskTable, true)
        printMask(wordMask, squigglyWord, biggestMask)

        io.write("Nova entrada: ")
        newLetter = io.read()
      end
    end
  end

  if menuOption ~= '3' then
    showMenu()
    menuOption = io.read()
  else
    menuOption = newLetter
  end
end
