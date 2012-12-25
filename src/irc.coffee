###
IRC interface for Fatbot

This interface will throw supported events, and listen to supported actions

API
===

Actions :

post      # Post a message to channel or user
leave       # Leave a channel
join      # Join a channel

Events :

message     # Catch all

self:connected  # Client is connected to server
self:talk   # Client is talking on the server
self:joined   # Client has joined a channel

user:message  # Hear a message
user:private  # Hear a private message
user:join     # Hear a join

###

irc = require 'irc'
{EventEmitter} = require 'events'

# Built-in servers configuration
servers =
  'dalnet': 'irc.dal.net'
  'efnet': 'irc.efnet.net'
  'freenode': 'irc.freenode.net'
  'mozilla': 'irc.mozilla.org'
  'quakenet': 'irc.quakenet.org'
  'undernet': 'us.undernet.org'

class IRC extends EventEmitter
  constructor: (@server, @username, @channels) ->

    @server = if @server of servers then servers[@server] else @server

    @client = new irc.Client @server, @username, channels: @channels

    ###
    Events
    ###

    @client.on 'registered', (msg) =>
      @emit 'self:connected', server: msg.server

    @client.on 'message', (from, to, message) =>
      if from is @username
        @emit 'self:talk', author: from, channel: to, message: message, account: @
      else
        @emit 'user:talk', author: from, channel: to, message: message, account: @

    @client.on 'pm', (from, text, message) =>
      @emit 'user:private', author: from, message: message, account: @

    @client.on 'join', (channel, nick, message) =>
      if nick is @username
        console.log "I've just joined #{channel}" # These logs should be in a sugar
        @emit 'self:join', channel: channel, username: nick, message: message, account: @
      else
        console.log "#{nick} has joined #{channel}"
        @emit 'user:join', channel: channel, username: nick, message: message, account: @

  ###
  Actions
  ###

  post: (text, channel) ->
    if channel?
      @client.say channel, text
    else
      for channel in @channels
        @client.say channel, text

  leave: (channel, callback) ->
    if channels in @channels
      @client.part channel, callback
      @channels.pop channel
      console.log "I leaved #{channel} !"
    else
      console.log "I can't leave #{channel}..."
    

  join: (channel, callback) ->
    @client.join channel, callback
    @chanels.push channel
    console.log "I should join #{channel}"

  ###
  Catch all events
  ###

  emit: (e, params...) ->
    super e, params...
    if e isnt '*'
      @emit '*',e,params...


exports.IRC = IRC