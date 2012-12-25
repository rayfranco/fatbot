{Fatbot}  = require '../src/fatbot.coffee'

# Refinery helpers
{hear}    = require '../refinery/hear'
{timer}   = require '../refinery/timer'

# Sugars
{register,lastseen} = require '../sugars/lastseen.coffee'
{logs}    = require '../sugars/lastseen.coffee'
{greets}  = require '../sugars/lastseen.coffee'

# Bot settings
settings =
  server: 'freenode',
  username: 'fatbot',
  channels: ['#fatbot']

# Instanciating the bot
b = new Fatbot settings

# Add some refinery helpers
b.refinery.add 'timer', timer
b.refinery.add 'hear', hear

# Create some sugars built by the refinery patten `hear`
b.refinery.hear /hello/, (msg) ->
  msg.reply "Hello #{msg.author} !"

b.refinery.hear /bye/, (msg) ->
  msg.reply "Goodbye #{msg.author} !"

# And using it after for inline sugar creation
b.refinery.timer 60000*5, () ->
  @bot.account.post 'I am so bored...','#fatbot'

# Add some sugars
b.sweeten register
b.sweeten lastseen
b.sweeten logs
b.sweeten greets

b.connect()