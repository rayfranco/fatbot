fs          = require 'fs'
irc         = require 'irc'
sty         = require 'sty'
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
  botDebug: false

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

  sugars = [] # Unused for now

  constructor: (settings, nick, channels) ->

    # Read package.json
    file = fs.readFileSync __dirname + '/../package.json', 'utf-8'
    @package =  JSON.parse file

    if typeof settings is 'string'
      @settings.server = settings
      @settings.nick = nick
      @settings.channels = channels
    else
      @settings = u.extend defaults, settings

    @prepClient()
    @prepEvents()
    @loadExtensions()

    @emit 'self:start'
      client: @client

  toString: () ->
    "#{@package.name}/#{@package.version} node/#{process.versions.node}"

  ###
  Sugars event dispatcher # Unused for now
  ###

  dispatch: (e, r) ->
  for sugar in sugars when sugar.listener is e
      sugar.callback(r)

  ###
  Connect the client
  ###

  connect: ->
    @client.connect()
    return

  ###
  Configure client and Events handlers
  ###

  prepClient: ->
    @settings.server  = if @settings.server of servers then servers[@settings.server] else @settings.server
    @client           = new irc.Client @settings.server, @settings.nick,
      userName: @settings.username
      realName: @settings.realname
      port:     @settings.port
      channels: @settings.channels
      autoConnect: false
      autoRejoin: true

  prepEvents: ->
    @client.on 'error', (err) ->
      @emit 'client:error', err

    @client.on 'registered', (msg) =>
      @emit 'self:connected'
        server: msg.server

    @client.on 'message', (from, to, message) =>
      if to isnt @settings.nick
        @emit 'user:talk'
          nick: from
          channel: to
          text: message
          client: @client
          reply: (txt) => @say txt, to

    @client.on 'pm', (from, text, message) =>
      @emit 'user:private'
        nick: from
        text: text
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
          reply: (txt) => @say txt, channel

  debug: (n,d) ->
    if @settings.botDebug
      console.log "[#{sty.bold 'debug'}](#{sty.red sty.bold n}) #{sty.bold d}"

  # This is temporary, do not use
  loadExtensions: ->

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
      @emit 'self:talk'
          channel: channel
          text: text
          client: @client
    else
      for channel in @channels
        @emit 'self:talk'
          channel: channel
          text: text
          client: @client
        @client.say channel, text

  leave: (channel, callback) ->
    if channels in @channels
      @client.part channel, callback
      @channels.pop channel
    
  join: (channel, callback) ->
    @client.join channel, callback
    @chanels.push channel


###
Built-in extensions
###

Bot::hear = (regex,callback) ->
  @on 'user:talk', (r) ->
    if r.text.match regex
      callback(r)

Bot::loadExtensions = ->
  if @settings.botDebug
    @on '*', (e,r) ->
      @debug e r
  @on 'self:start', ->
    version = @toString()
    console.log "[#{sty.bold sty.green version}] I'm #{sty.bold sty.cyan 'loaded'}, ready to connect !"
  @on 'self:connected', (r) ->
    console.log "I'm connected to #{sty.green sty.bold r.server}"
  @on 'self:join', (r) ->
    console.log "I've just joined #{sty.yellow r.channel}"
  @on 'self:talk', (r) ->
    console.log "[#{sty.bold sty.red r.channel}] #{sty.green r.text}"
  @on 'user:private', (r) ->
    console.log "[#{sty.bold sty.red 'private'}] #{sty.green r.nick}: #{r.text}"

module.exports.Bot = Bot