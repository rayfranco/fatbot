class Sugar
  constructor: (@on, @do, @if = true) ->
    if typeof @if isnt 'function'
      @if = () ->  true
module.exports.Sugar = Sugar