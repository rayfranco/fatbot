{Sugar} = require '../src/sugar.coffee'

callback = (msg) ->
  msg.account.post("Hello #{msg.username} !",msg.channel)

module.export.hello = new Sugar 'user:join', callback

