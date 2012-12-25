fs          = require 'fs'
u           = require 'underscore'
{IRC}       = require './irc'
{Sugar}     = require './sugar'
{Refinery}  = require './refinery'

# Built-in refinery tasks
hear        = require '../refinery/hear'

# Helpers

defaults =
  server:   'irc.freenode.net'      # Server to join
  username: 'fatbot'                # Bot name
  channels: ['#fatbot']             # Array of channels
  refineries: {}                    # Should be object of functions
  sugars:   []                      # Should be array of sugar syntax objects

class Fatbot

  constructor: (settings) ->
    @settings = u.extend(defaults,settings)

    @refinery = new Refinery @
    @refinery.add @settings.refineries
    #@refinery.add hear

    @irc      = server: @settings.server, username: @settings.username, channels: @settings.channels
    @sugars   = @settings.sugars
    @account  = null

  # When events are thrown, this will request sugars
  dispatch: (e, msg) ->
    for sugar in @sugars when sugar.on is e
      if not sugar.if? or sugar.if(msg)
        sugar.do(msg)

  # Connect the bot the server and set the account
  connect: (irc) ->
    if not irc? then irc = @irc
    @account  = new IRC irc.server, irc.username, irc.channels

    # Listen to all events
    @account.on '*', (e,params) =>
      @dispatch e, params

  refine: (helper,args...) ->
    @sweeten @refinery[helper].call(@)

  sweeten: (e,callback,condition) ->
    if typeof e is 'object'
      sugar = e
    else
      sugar = new Sugar e, callback, condition
      sugar.bot = @
    @sugars.push sugar

exports.Fatbot = Fatbot



