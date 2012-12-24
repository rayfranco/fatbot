{Fatbot} = require '../src/fatbot.coffee'

b = new Fatbot
  server: 'irc.freenode.net',
  username: 'boulbot',
  channels: ['#fatbot','#boulbot']

# The refinery task hear is built-in
b.refinery.hear /hello/, (msg) ->
  msg.reply "Hello #{msg.author} !"

b.connect()