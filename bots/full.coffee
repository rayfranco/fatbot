{Fatbot} = require '../src/fatbot.coffee'

# Bot settings
settings =
  server: 'freenode',
  username: 'fatbot',
  channels: ['#fatbot']

# Instanciating the bot
b = new Fatbot settings

# We add can load refinery patterns from files
b.refinery.add require '../refinery/hear'

# We can add inline refinery patterns
b.refinery.add
  timer: (time,callback) ->
    sugar =
      on: 'self:connected'
      do: () =>
        c = () => callback.call(@account)
        setInterval c, time

# And using it after for inline sugar creation
b.refinery.timer 60000*5, () ->
  @post 'I am so bored...','#fatbot'

# Create some sugars built by the refinery patten `hear`
b.refinery.hear /hello/, (msg) ->
  msg.reply "Hello #{msg.author} !"

b.refinery.hear /bye/, (msg) ->
  msg.reply "Goodbye #{msg.author} !"

# Add some inline sugar
b.sweeten
  on: 'user:connect'
  if: (msg) ->
    msg.username isnt 'fatbot'
  do: (msg) ->
    msg.account.post "Welcome on #{msg.channel}, #{msg.username} !", msg.channel

b.connect()