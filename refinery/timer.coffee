{Sugar} = require '../src/sugar'

timer = (time,c) ->
  callback = () => 
      c()
      setInterval c, time
  new Sugar 'self:connected', callback

module.exports.timer = timer