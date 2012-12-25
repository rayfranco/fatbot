{Sugar} = require '../src/sugar'

console.log 'loading logs'

join = new Sugar "user:join", (msg) ->
  console.log "#{msg.author} has joined the channel #{msg.channel}"
pm = new Sugar "user:private", (msg) ->
  console.log msg
  console.log "#{msg.author} has sent you a PM : #{msg.message}"

logs =
  join: join
  pm: pm

module.exports.logs = logs