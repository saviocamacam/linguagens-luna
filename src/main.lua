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

local function searchWords(conteudo, tamanhoPalavra)
	local todasPalavras = mysplit(conteudo, "%p+%s")
	for k, v in pairs(todasPalavras) do
    print(k, v)
  end
end

local function imprimeTabela(tabela)
  for k, v in pairs(tabela) do
    print(k, v)
  end
end

local function pegarPalavrasNoTamanho(palavras, tamanho)
  local palavrasNoTamanho = {}
  for k, v in pairs(palavras) do
    if utf8.len(v) == tamanho then
      table.insert(palavrasNoTamanho, v)
    end
  end
  return palavrasNoTamanho
end

local function naoNaTabela(palavrasSelecionadas, wordIn)
  for k, v in pairs(palavrasSelecionadas) do
    if v == wordIn then
      return false
    end
  end
  return true
end

local function pegarIndiceTabela(palavrasSelecionadas, wordIn)
  for k, v in pairs(palavrasSelecionadas) do
    if v == wordIn then
      return k
    end
  end
  return -1
end

local function letraNaPalavra(palavraPrincipal, char, bool, tabelaLetras)
  if bool then
    imprimeTabela(tabelaLetras)
  end

  for c in newUtf8.gmatch(palavraPrincipal, ".") do
    if c == char and tabelaLetras[c] > 0 then
      tabelaLetras[c] = tabelaLetras[c] - 1
      return true
    end
  end
  return false
end

local function selectWords(todasPalavras, tamanhoPalavra)
  local palavrasTamanhoN = pegarPalavrasNoTamanho(todasPalavras, tamanhoPalavra)
  local posicao = math.random(#palavrasTamanhoN)
  local palavraPrincipal = palavrasTamanhoN[posicao]
  local palavrasMinimoMaximo = {}
  local palavrasSelecionadas = {}

  for k, v in pairs(todasPalavras) do
    if utf8.len(v) <= tamanhoPalavra then
      table.insert(palavrasMinimoMaximo, v)
    end
  end

  local contador = 0
  for k, v in pairs(palavrasMinimoMaximo) do

    local tabelaLetras = {}
    for c in newUtf8.gmatch(palavraPrincipal, ".") do
      if not tabelaLetras[c] then
        tabelaLetras[c] = 1
      else
        tabelaLetras[c] = tabelaLetras[c] + 1
      end
    end

    for c in newUtf8.gmatch(v, ".") do

      local boolean = letraNaPalavra(palavraPrincipal, c, bool, tabelaLetras)
      if boolean then
        contador = contador + 1
      end
    end

    if contador == utf8.len(v) and naoNaTabela(palavrasSelecionadas, v) then
      table.insert(palavrasSelecionadas, v)
    end
    contador = 0
  end

  --imprimeTabela(palavrasSelecionadas)
  print("Principal: ", posicao, palavraPrincipal)
  return palavrasSelecionadas, palavraPrincipal
end

function criarMascara(palavrasSelecionadas)
  local mascarasPalavras = {}
  local a = ""
  local maiorMascara = ""
  local maiorMascaraTabela = {}
  for k, v in pairs(palavrasSelecionadas) do
    for c in newUtf8.gmatch(v, ".") do
      a = a .."_ "
    end
    if utf8.len(a) > utf8.len(maiorMascara) then
      maiorMascara = a
      maiorMascaraTabela = {}
      for c in newUtf8.gmatch(a, ".") do
        table.insert(maiorMascaraTabela, c)
      end
    end
    table.insert(mascarasPalavras, a)
    a = ""
  end
  return mascarasPalavras, maiorMascaraTabela
end

function embaralhaTabelaPalavra(palavraEmbaralhadaTabela)
  local i = 1
  local tabelaPosicoes = {}
  while i ~= #palavraEmbaralhadaTabela do
    local posicao1 = math.random(#palavraEmbaralhadaTabela)
    local letra1 = palavraEmbaralhadaTabela[posicao1]

    local posicao2 = math.random(#palavraEmbaralhadaTabela)
    local letra2 = palavraEmbaralhadaTabela[posicao2]

    palavraEmbaralhadaTabela[posicao2] = letra1
    palavraEmbaralhadaTabela[posicao1] = letra2
    i = i + 1
  end
end

function embaralhaPalavra(palavraPrincipal)
  local palavraPrincipalTabela = {}
  local palavraEmbaralhadaTabela = {}
  local tabelaPosicoes = {}
  for c in newUtf8.gmatch(palavraPrincipal, ".") do
    table.insert(palavraPrincipalTabela, c)
  end

  local i = 1
  while i ~= #palavraPrincipalTabela+1 do
    local posicao = math.random(#palavraPrincipalTabela)
    local letra = palavraPrincipalTabela[posicao]
    if naoNaTabela(tabelaPosicoes, posicao) then
      table.insert(tabelaPosicoes, posicao)
      table.insert(palavraEmbaralhadaTabela, letra)
      i = i + 1
    end
  end

  return palavraEmbaralhadaTabela
end

function tabelaParaString(palavraEmbaralhadaTabela, bool)
  local palavraEmbaralhada = ""
  for k, v in pairs(palavraEmbaralhadaTabela) do
    if bool then
      palavraEmbaralhada = palavraEmbaralhada .. v .." "
    end
    if v ~= '_' and v ~= ' ' and not bool then
      palavraEmbaralhada = palavraEmbaralhada .. v
    end
  end
  return palavraEmbaralhada
end

function exibirMenu()
  print('LunaLetroca')
	print('[1]: Pesquisar novo tema')
	print('[2]: Informar tamanho da palavra')
  print('[3]: Embaralhar letras')
  print("[4]: Modo trapaça")
	print('[6]: Sair')
end

function imprimeMascara(mascarasPalavras, palavraEmbaralhada, maiorMascara)
  imprimeTabela(mascarasPalavras)
  print("\nSquiggly Word: ", palavraEmbaralhada)
  print("\nMascara: ", maiorMascara)
end

function insereLetra(maiorMascaraTabela, novaLetra)
  for k, v in pairs(maiorMascaraTabela) do
    if v == '_' then
      maiorMascaraTabela[k] = novaLetra
      return
    end
  end
end

function removeLetra(palavraEmbaralhadaTabela, novaLetra)
  for k, v in pairs(palavraEmbaralhadaTabela) do
    if v == novaLetra then
      table.remove(palavraEmbaralhadaTabela, k)
      return
    end
  end
end

function resetMaiorMascara(mascaraPalavraTabela)
  for k, v in pairs(mascaraPalavraTabela) do
    if v ~= ' ' and v ~= '_' then
      mascaraPalavraTabela[k] = '_'
    end
  end
end

function pop(mascaraPalavraTabela)
  for k, v in pairs(mascaraPalavraTabela) do
    if v == '_' and k > 2 then
      local letra = mascaraPalavraTabela[k-2]
      mascaraPalavraTabela[k-2] = '_'
      return letra
    end
    if k == #mascaraPalavraTabela then
      local letra = mascaraPalavraTabela[k-1]
      mascaraPalavraTabela[k-1] = '_'
      return letra
    end
  end
end

function pull(palavraEmbaralhadaTabela, letra)
  table.insert(palavraEmbaralhadaTabela, letra)
end

--exibirMenu()
--print("Pesquise um tema: ")
opcaoMenu = '1'
conteudo = ""
palavrasSelecionadas = nil

while opcaoMenu ~= '6' do
	if opcaoMenu == '1' then
		io.write("Digite um tema a ser pesquisado: ")
		tema = string.format("%s", io.read())
		print("Fazendo a requisição no Wikipedia...")
		json = conn.getpage(tema)
		print("Fazendo parsing...")

		conteudo = parser.parse(json)
		--print("\n", conteudo)

    if conteudo == "" then
      print("Nenhum resultado para essa pesquisa!")
    end

    if conteudo ~= nil then
      todasPalavras = mysplit(conteudo, " ,.\n")
    end

  end

	if opcaoMenu == '2' then
    if conteudo == "" then
      print("Nenhum resultado para essa pesquisa!")
    else

      print('Qual o tamanho maximo da palavra?')
  		tamanhoPalavra = io.read("*number")
  		print("Pesquisando palavras...")

      palavrasSelecionadas, palavraPrincipal = selectWords(todasPalavras, tamanhoPalavra)
      --imprimeTabela(palavrasSelecionadas)
      mascarasPalavras, maiorMascaraTabela = criarMascara(palavrasSelecionadas)

      palavraEmbaralhadaTabela = embaralhaPalavra(palavraPrincipal)
      palavraEmbaralhada = tabelaParaString(palavraEmbaralhadaTabela, true)
    end
	end

  if opcaoMenu == '3' then

    if conteudo == "" or palavrasSelecionadas == nil then
      print("Nenhum resultado para essa pesquisa!")
    else
      palavraEmbaralhadaTabela = embaralhaPalavra(palavraPrincipal)
      palavraEmbaralhada = tabelaParaString(palavraEmbaralhadaTabela, true)
      maiorMascara = tabelaParaString(maiorMascaraTabela, true)
      imprimeMascara(mascarasPalavras, palavraEmbaralhada, maiorMascara)
      io.write("Nova entrada: ")
      local novaLetra = io.read()

      while novaLetra ~= '1' and novaLetra ~= '2'--[[ and novaLetra ~= '3']] do
        if not naoNaTabela(palavraEmbaralhadaTabela, novaLetra) then
          print("tem: ", novaLetra)

          insereLetra(maiorMascaraTabela, novaLetra)
          removeLetra(palavraEmbaralhadaTabela, novaLetra)
          palavraEmbaralhada = tabelaParaString(palavraEmbaralhadaTabela, true)
          maiorMascara = tabelaParaString(maiorMascaraTabela, true)
          imprimeMascara(mascarasPalavras, palavraEmbaralhada, maiorMascara)

        else
          print("\nEssa letra nao pertence a palavra: ", novaLetra)
          imprimeMascara(mascarasPalavras, palavraEmbaralhada, maiorMascara)
        end
        io.write("\n[1 | 2]: Menu [3]: Embaralhar [4]: Modo trapaça\n Testar? >> ! : ")
        io.write("Nova entrada: ")
        novaLetra = io.read()

        if novaLetra == '3' then
          embaralhaTabelaPalavra(palavraEmbaralhadaTabela)
          palavraEmbaralhada = tabelaParaString(palavraEmbaralhadaTabela, true)
          imprimeMascara(mascarasPalavras, palavraEmbaralhada, maiorMascara)
        end

        if novaLetra == '4' then
          imprimeTabela(palavrasSelecionadas)
        end

        if novaLetra == '!' then
          PalavraTeste = tabelaParaString(maiorMascaraTabela, false)
          print("Para teste: ", PalavraTeste)
          indicePalavra = pegarIndiceTabela(palavrasSelecionadas, PalavraTeste)

          if indicePalavra > 0 then
            print("\nEssa palavra existe!")
            mascarasPalavras[indicePalavra] = PalavraTeste
            resetMaiorMascara(maiorMascaraTabela)

            palavraEmbaralhadaTabela = embaralhaPalavra(palavraPrincipal)
            palavraEmbaralhada = tabelaParaString(palavraEmbaralhadaTabela, true)
            maiorMascara = tabelaParaString(maiorMascaraTabela, true)
            imprimeMascara(mascarasPalavras, palavraEmbaralhada, maiorMascara)
            io.write("Nova entrada: ")
            novaLetra = io.read()

          else
            print("\nEssa palavra nao existe aqui!")
            imprimeMascara(mascarasPalavras, palavraEmbaralhada, maiorMascara)
            io.write("Nova entrada: ")
            novaLetra = io.read()
          end
        end

        if novaLetra == '*' then
          letraRemovida = pop(maiorMascaraTabela)
          print("l: ", letraRemovida)
          pull(palavraEmbaralhadaTabela, letraRemovida)
          palavraEmbaralhada = tabelaParaString(palavraEmbaralhadaTabela, true)
          maiorMascara = tabelaParaString(maiorMascaraTabela, true)
          imprimeMascara(mascarasPalavras, palavraEmbaralhada, maiorMascara)

          io.write("Nova entrada: ")
          novaLetra = io.read()
        end

      end --end do while
    end --end do else do conteudo
  end -- end do menuOption 3

  if opcaoMenu == '4' then
    if conteudo == "" or palavrasSelecionadas == nil then
      print("Nenhum resultado para essa pesquisa!")
    else
      imprimeTabela(palavrasSelecionadas)
    end
  end

  if opcaoMenu ~= '3' then
    exibirMenu()
    opcaoMenu = io.read()
  else
    opcaoMenu = novaLetra
  end
end
