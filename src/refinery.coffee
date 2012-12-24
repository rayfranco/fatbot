class Refinery

  constructor: (@bot) ->

  add: (helpers,helper) ->
    if typeof helpers is 'object'
      for name, helper of helpers
        Refinery::[name] = (args...) =>
          h = helper.call(@, args...)
          @bot.sugars.push h
    else
      Refinery::[helpers] = (args...) =>
        h = helper.call(@, args...)
        @bot.sugars.push h

module.exports.Refinery = Refinery
