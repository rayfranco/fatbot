class Response
  nick     : '' # The emmiter
  to       : '' # The receiver (if apply)
  channel  : '' # The channel
  server   : '' # The server
  text     : '' # The text sent

  client   : new Object()  # The IRC client reference

  # A Shortcut to send a message on the concerned channel
  reply: (txt) ->
        

  ###
  These methods are drafts
  ###

  # A shortcut to send a whois to the emmiter
  whois: ->
  # A shortcut to kick
  kick: (reason) ->
  # A shortcut to ban
  ban: ->
  # A shortcut to 