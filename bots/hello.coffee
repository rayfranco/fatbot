{Fatbot} = require '../src/fatbot.coffee'

settings =
	server: 'freenode',
	username: 'fatbot',
	channels: ['#fatbot']

b = new Fatbot settings

# Listening to bye on channels
b.hear /bye/, (msg) ->
	msg.reply "Goodbye #{msg.author} !"

b.sweeten('hello')

b.connect()