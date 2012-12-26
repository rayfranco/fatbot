fs          = require 'fs'
irc         = require 'irc'
u           = require 'underscore'
events      = require 'events'

defaults =
  server: 'freenode'
  nick: 'fatbot'
  username: 'fatbot'
  realname: 'Fatbot, a coffeescript IRC bot'
  port: 6667
  channels: ['#fatbot']
  autoConnect: false

servers =
  'dalnet': 'irc.dal.net'
  'efnet': 'irc.efnet.net'
  'freenode': 'irc.freenode.net'
  'mozilla': 'irc.mozilla.org'
  'quakenet': 'irc.quakenet.org'
  'undernet': 'us.undernet.org'

class Bot extends events.EventEmitter

  ###
  Constructor
  ###

  constructor: (settings, nick, channels) ->
    if typeof settings is 'string'
      @settings.server = settings
      @settings.nick = nick
      @settings.channels = channels
    else
      @settings = u.extend defaults, settings

    console.log @settings.server

    prepClient.call @
    prepEvents.call @

  ###
  Connect the client
  ###

  connect: () ->
    @client.connect()
    return

  ###
  Configure client and Events handlers
  ###

  prepClient = ->
    console.log 'PREP CLIENT'
    @settings.server  = if @settings.server of servers then servers[@settings.server] else @settings.server
    @client           = new irc.Client @settings.server, @settings.nick,
      userName: @settings.username
      realName: @settings.realname
      port:     @settings.port
      channels: @settings.channels
      autoConnect: false
      autoRejoin: true

  prepEvents = ->
    @client.on 'error', (err) ->
      console.log err
      @emit 'client:error', err

    @client.on 'registered', (msg) =>
      @emit 'self:connected'
        server: msg.server

    @client.on 'message', (from, to, message) =>
      if from is @settings.nick
        @emit 'self:talk'
          nick: from
          channel: to
          text: message
          client: @client
      else
        @emit 'user:talk'
          nick: from
          channel: to
          text: message
          client: @client
          reply: (txt) => @say txt, to

    @client.on 'pm', (from, text, message) =>
      @emit 'user:private'
        nick: from
        text: message
        client: @client
        reply: (txt) => @say txt, from

    @client.on 'join', (channel, nick, message) =>
      if nick is @settings.nick
        @emit 'self:join'
          channel: channel
          nick: nick
          text: message
          client: @client
      else
        @emit 'user:join'
          channel: channel
          nick: nick
          text: message
          client: @client
    
  ###
  Catch all events
  ###

  emit: (e, params...) ->
    super e, params...
    if e isnt '*'
      @emit '*', e, params...

  ###
  IRC basic interface
  ###

  say: (text, channel) ->
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

module.exports.Bot = Bot