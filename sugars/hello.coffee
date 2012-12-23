# A sugar is a plugin that can be built within a bot for feature specific logic

# This is a draft

{Sugar} = require '../src/sugar.coffee'

greet =
	on: 'user:join'
	do: (msg) ->
		msg.account.post("Hello #{msg.username} !",msg.channel)
	if: () ->
		true

bot.sweeten(greet)