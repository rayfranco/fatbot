   ____          __    ____            __      
  /\  _`\       /\ \__/\  _`\         /\ \__
  \ \ \L\_\ __  \ \ ,_\ \ \L\ \    ___\ \ ,_\
   \ \  _\/'__`\ \ \ \/\ \  _ <'  / __`\ \ \/
    \ \ \/\ \L\.\_\ \ \_\ \ \L\ \/\ \L\ \ \ \_ 
     \ \_\ \__/.\_\\ \__\\ \____/\ \____/\ \__\
      \/_/\/__/\/_/ \/__/ \/___/  \/___/  \/__/


FatBot is an easy to use and extensible coffescript IRC bot framework.

**NOTE : This README.md is used as specs for now. This is still a draft at some points.**

Quick start
===========

Here is an example of a simple hello bot :

```coffeescript
require 'fatbot'

b = new Fatbot
  server: 'freenode',
  username: 'fatbot',
  channels: ['#fatbot']

# The refinery task hear is built-in
b.refinery.hear /hello/, (msg) ->
  msg.reply "Hello #{msg.author} !"

b.connect()
```

Then launch your bot :

```coffeescript
coffee mybot
```


Build from sources
==================

To build from sources, clone this repo :

`git clone https://github.com/RayFranco/fatbot.git`

Then from the repo root folder, install the dependencies :

`npm install`

You can now create your bot or try one frome the example in the folder `./bots/`

Use cake task `bot:start` to start a bot :

`cake -b simple bot:start`

Here we are starting the example bot called `simple.coffee`


Sugars
======

Sugars are behaviors. For example, saying hello to a user that connects to a channel.
Sugars are object literals that contains multiple parameters :

<table>
  <tr>
    <th>Parameter</th>
    <th>Required</th>
    <th>Arguments</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>`on`</td>
    <td>true</td>
    <td>String event</td>
    <td>When to trigger the callback</td>
  </tr>
  <tr>
    <td>`do`</td>
    <td>true</td>
    <td>Function callback(Message msg)</td>
    <td>What to do when event occurs</td>
  </tr>
  <tr>  
    <td>`if`</td>
    <td>false</td>
    <td>Function boolean(Message msg)</td>
    <td>This have to be null or true for the callback to be executed</td>
  </tr>
</table>

Here is a sugar on top of 'hear' built-in refinery helper that says hello to a user that says 'hello' :

```coffeescript
b.hear /hello/, (msg) ->
  msg.reply "Hello #{msg.author} !"
```

To build a sugar without passing by a refinery helper, just call `Fatbot.prototype.sweeten` method and return a sugar-structured object :

```coffeescript
b.sweeten
  on: 'user:connect'
  if: (msg) ->
    msg.username isnt 'fatbot'
  do: (msg) ->
    msg.account.post "Welcome on #{msg.channel}, #{msg.username} !", msg.channel
```

Refinery
========

The refinery is a sugar factory, it offers several methods (helpers) that create sugars quickly, with it's own logic.

Here is a refinery helper to test a regex on `user:message` event :

```coffeescript
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
```

Events
======

These are the events thrown by the IRC interface (@account)

<table>
	<tr>
		<th>Event name</th>
		<th>Description</th>
		<th>Parameters</th>
	</tr>
	<tr>
		<td>`self:connected`</td>
		<td>Bot is connected to server</td>
		<td>{String server}</td>
	</tr>
	<tr>
		<td>`self:talk`</td>
		<td>Bot is talking</td>
		<td>{String author, String channel, Object account}</td>
	</tr>
	<tr>
		<td>`self:join`</td>
		<td>Bot is joining a channel</td>
		<td>{String channel, String username, Object message, Object account}</td>
	</tr>
	<tr>
		<td>`user:talk`</td>
		<td>User is talking in channel</td>
		<td>{String author, String channel, Object message, Object account}</td>
	</tr>
	<tr>
		<td>`user:private`</td>
		<td>User send pm to the bot</td>
		<td>{String author, String channel, Object message, Object account}</td>
	</tr>
	<tr>
		<td>`user:join`</td>
		<td>User join a channel</td>
		<td>{String channel, String username, Object message, Object account}</td>
	</tr>

</table>