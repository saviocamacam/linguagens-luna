print("Hellow World, Rickkftime viado!")

local conexao. = require('conection')

function getPlainText(body)
  print(body)
end


while menuOption ~= "6" do
  print("LunaLetroca")
  menuOption = io.read()

  print("(1) Pesquisar novo tema\n")

  if menuOption == "1" then
    theme = io.read()
    body = conexao.getPage(theme)

    hardText = getPlainText(body)
    filteredText = filterText(hardText)

    print("(2) ")

  end

end
