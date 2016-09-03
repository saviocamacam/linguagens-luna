luajson = require('lunajson')
https =require('ssl.https')


json = https.request('https://pt.wikipedia.org/w/api.php?action=query&format=json&utf8=1&prop=extracts&explaintext=1&exsectionformat=plain&titles=computa%C3%A7%C3%A3o_gr%C3%A1fica')
t = luajson.decode(json)


print(t.query)

for k,v in pairs(t.query.pages) do
	print(v.extract)
end
