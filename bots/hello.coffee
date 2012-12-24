{Fatbot} = require '../src/fatbot.coffee'

settings =
  server: 'freenode',
  username: 'fatbot',
  channels: ['#fatbot']

b = new Fatbot settings

# Inline sugars
b.hear /bye/, (msg) ->
  msg.reply "Goodbye #{msg.author} !"

b.hear /hello/, (msg) ->
  msg.reply "Hello #{msg.author} !"

b.timer 60000*5, () ->
  @post 'I am so bored...','#fatbot'

b.connect()