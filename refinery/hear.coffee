module.exports.hear = (regex,callback) ->
  sugar =
    on: 'user:talk'
    do: callback
    if: (msg) ->
      msg.match = msg.message.match regex
      if msg.match
        msg.reply = (txt) ->
          msg.account.post(txt,msg.channel)
        return true
      else
        return false