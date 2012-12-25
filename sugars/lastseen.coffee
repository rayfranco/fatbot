dict = {}

# This sugar will register all users talking
module.exports.register =
  on: 'user:talk'
  do: (msg) ->
    msg.date = new Date().toJSON()
    dict[msg.author] = msg

# This sugar will answer to `!lastseen nick`
module.exports.lastseen =
  on: 'user:talk'
  if: (msg) ->
    if match = msg.message.match /\!lastseen (\w+)/
      msg.findUser = match[1]
      return true
    else
      return false
  do: (msg) ->
    if dict[msg.findUser]?
      lastseen = dict[msg.findUser]
      date = new Date(lastseen.date).toDateString()
      txt = "#{msg.author}: I've seen #{lastseen.author} on #{date} in channel #{lastseen.channel}"
    else
      txt = "#{msg.author}: #{msg.findUser} ? Who's that ?"
    msg.account.post txt, msg.channel