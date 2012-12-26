fatbot = require '../lib/fatbot'

b = new fatbot.Bot
  server: 	'192.168.0.202',
  nick: 	'fatbot',
  channels: ['#fatbot']

# # The refinery task hear is built-in
# b.refinery.hear /hello/, (msg) ->
#   msg.reply "Hello #{msg.author} !"

b.on 'user:talk', (r) ->
  #console.log(r)
  if r.text.match /hello/
  	r.reply "Hello johnny"

b.bind 'sugar:match', /hello/, (r) ->
    r.reply "Hello #{r.nick} !"

b.addSugar 'match', 'user:talk', (r,regex,callback) ->
    if match = r.text.match regex and typeof callback is 'function'
        callback(r)


b.on '*', (e,r) ->
  #console.log e,r

b.connect()