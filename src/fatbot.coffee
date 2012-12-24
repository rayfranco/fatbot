# Here will be the Bot logic

fs    = require 'fs'
{IRC} = require './irc'

# Helpers

hear  = require '../refineries/hear'

defaults =
  server:   'barjavel.freenode.net'
  username: 'fatbot'
  channels: ['#fatbot']
  refineries: [hear]                # Should be array of functions
  sugars:   []

class Fatbot

  constructor: (@settings) ->
    settings  = defaults # Should merge settings and defaults
    @irc      = server: settings.server, username: settings.username, channels: settings.channels
    @handlers = []
    @refine   = settings.refineries
    @sugars   = settings.sugars
    @account  = null

    # Adding built-in sugars
    @sugars.connect = @connect
    @sugars.hear  = @hear

  # When events are thrown, this will request handlers
  dispatch: (e, msg) ->
    for handler in @handlers when handler.on is e
      if not handler.if? or handler.if(msg)
        handler.do(msg)

  # Built-in helper
  hear: (regex,callback) ->
    handler =
      on: 'user:talk'
      do: callback
      if: (msg) ->
        msg.match = msg.message.match regex
        if msg.match
          msg.reply = (txt) ->
            msg.account.post(txt,msg.channel)
            console.log "replying #{txt} in #{msg.channel}"
          return true
        else
          return false
    @handlers.push handler

  # Refinery helpers
  timer: (time,callback) ->
    handler =
      on: 'self:connected'
      do: () =>
        c = () => callback.call(@account)
        setInterval c, time
    @handlers.push handler

  # Connect the bot the server and set the account
  connect: (irc) ->
    # Connect to server
    if not irc? then irc = @irc
    @account  = new IRC @irc.server, @irc.username, @irc.channels

    # Listen to all events
    @account.on '*', (e,params) =>
      @dispatch e, params

  sweeten: (sugar) ->
    @sugars.push sugar

exports.Fatbot = Fatbot



