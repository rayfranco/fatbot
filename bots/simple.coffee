fatbot = require '../lib/fatbot'

bot = new fatbot.Bot
  server:   '192.168.0.202',
  nick:   'fatbot',
  channels: ['#fatbot','#skinnybot']
  botDebug: false

# Listen to Bot events

bot.on 'user:join', (r) ->
  r.reply "Welcome to #{r.channel}, #{r.nick} !"

# Extending bot prototype

fatbot.Bot::hear = (regex,callback) ->
  @on 'user:talk', (r) ->
    if r.text.match regex
      callback(r)

# Using newly created extensions

bot.hear /hello/, (r) ->
  r.reply "Hello #{r.nick} !"

bot.hear /bye/, (r) ->
  r.reply "Good bye #{r.nick}"

bot.connect()