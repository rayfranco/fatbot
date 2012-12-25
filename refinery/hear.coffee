###
Hear - Refinery helper

Use like this :

    use.refinery.hear /hello/, (msg) ->
      match = msg.match
      msg.reply "Hello #{msg.author} !"
###

{Sugar} = require '../src/sugar'

hear = (regex,callback) ->
  condition = (msg) ->
    msg.match = msg.message.match regex
    if msg.match
      msg.reply = (txt) ->
        msg.account.post(txt,msg.channel)
      return true
    else
      return false

  new Sugar 'user:talk', callback, condition

module.exports.hear = hear