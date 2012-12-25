{Fatbot} = require '../src/fatbot.coffee'

b = new Fatbot
  server: 'freenode',
  username: 'fatbot',
  channels: ['#fatbot']

# The refinery task hear is built-in
b.refinery.hear /hello/, (msg) ->
  msg.reply "Hello #{msg.author} !"

b.connect()