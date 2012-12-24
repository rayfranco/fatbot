{exec} = require 'child_process'

option '-b','--bot [BOT]', 'Start a specific bot'
task "bot:start", "Start a bot", (options) ->
  if not options.bot?
    throw "Bot is missing, use this task like this :\r\n\r\ncake -b mybot bot:start"
  if typeof options.bot isnt 'string'
    throw "Can't build that bot mate... Check your parameters\r\n\r\ncake -b mybot bot:start"
  coffee = exec 'coffee ./bots/'+options.bot, (err,output) ->
    if err
      throw "Seems like a wrong name for a bot... Make sure this file exists : ./bot/"+options.bot+".coffee"
  coffee.stdout.on 'data', (data) -> console.log data.toString().trim()
