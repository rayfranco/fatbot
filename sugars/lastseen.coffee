dict = {}

module.exports.register =
  on: 'user:talk'
  do: (msg) ->
    msg.date = new Date().toJSON()
    dict[msg.author] = msg
module.exports.lastseen =
  on: 'user:talk'
  if: (msg) ->
    if match = msg.message.match /\!lastseen (\w+)/
      msg.findUser = match[1]
      console.log 'find', msg.findUser
      return true
    else
      return false
  do: (msg) ->
    txt = "#{msg.author}: #{msg.findUser} ? Who's that ?"
    if dict[msg.findUser]?
      console.log "Found !"
      lastseen = dict[msg.findUser]
      date = new Date(lastseen.date).toDateString()
      txt = "#{msg.author}: I've seen #{lastseen.author} on #{date} in channel #{lastseen.channel}"
    msg.account.post txt, msg.channel