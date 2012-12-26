```ascii
    ______      __  ____        __ 
   / ____/___ _/ /_/ __ )____  / /_
  / /_  / __ `/ __/ __  / __ \/ __/
 / __/ / /_/ / /_/ /_/ / /_/ / /_  
/_/    \__,_/\__/_____/\____/\__/  
```

FatBot is an easy to use and extensible coffescript IRC bot framework.

Quick start
===========

Create a file `mybot.coffee`

Install fatbot via npm

    npm install fatbot

Here is an example of a simple bot :

```coffeescript
fatbot = require 'fatbot'

bot = new fatbot.Bot
  server:   'freenode',
  nick:   'mybot',
  channels: ['#mycoolchan']

# Listen to Bot events

bot.on 'user:join', (r) ->
  r.reply "Welcome to #{r.channel}, #{r.nick} !"

# Extending bot prototype

fatbot.Bot::hear = (regex,callback) ->
  @on 'user:talk', (r) ->
    if r.text.match regex
      callback(r)

# Using newly created extensions

bot.hear /hello/, (r) ->
  r.reply "Hello #{r.nick} !"

bot.hear /bye/, (r) ->
  r.reply "Good bye #{r.nick}"

bot.connect()
```

Then launch your bot :

```coffeescript
coffee mybot
```

In this example, you are :

* Connecting `mybot` to a built-in server shortcut called `freenode` and join a channel called `#mycoolchan`
* Perform action on events with `Fatbot::on`
* Extending the prototype for event listening automation : `Fatbot::hear`
* Using the extension `Fatbot::hear`
* Launching the bot with `Fatbot::connnect` method


Build from sources
==================

To build from sources, clone this repo :

    git clone https://github.com/RayFranco/fatbot.git

Then from the repo root folder, install the dependencies :

    npm install

You can now create your bot or try one frome the example in the folder `./bots/`

Use cake task `bot:start` to start a bot :

    cake -b simple bot:start

Above, we are launching the example bot called `simple.coffee`

Extending the Bot
=================

To extend the bot, we are simply extending the `fatbot.Bot`. This might me a little risky, if you'd tries to overwrite Bot methods (like *constructor*, *connect*, *say* or any other methods).
You should be aware of what methods you are adding to the Bot.

In the future, I'd like to add these helpers in a different namespace (*sugars*).

For more informations, see the [Classes section of coffeescript](http://coffeescript.org/#classes) to understand how to extend the prototype, especially with the `::` operator.

Events
======

You can easily add behaviors to the bot by listening to events :

```coffeescript
bot.on 'user:join', (r) ->
  r.reply "Welcome to #{r.channel}, #{r.nick} !"
```

`r` is the Response object.

These are the events thrown by the bot. Check the Response object section for more informations

<table>
	<tr>
		<th>Event name</th>
		<th>Description</th>
		<th>Response</th>
	</tr>
  <tr>
    <td> `client:error` </td>
    <td>Error sent by the client</td>
    <td>err (isnt Response object)</td>
  </tr>
	<tr>
		<td> `self:connected` </td>
		<td>Bot is connected to server</td>
		<td>server</td>
	</tr>
	<tr>
		<td> `self:talk` </td>
		<td>Bot is talking</td>
		<td>nick, text, client, reply(txt)</td>
	</tr>
	<tr>
		<td> `self:join` </td>
		<td>Bot is joining a channel</td>
		<td>channel, nick, text, client</td>
	</tr>
	<tr>
		<td> `user:talk` </td>
		<td>User is talking in channel</td>
		<td>nick, channel, text, client, reply(txt)</td>
	</tr>
	<tr>
		<td> `user:private` </td>
		<td>User send pm to the bot</td>
		<td>nick, text, client</td>
	</tr>
	<tr>
		<td> `user:join` </td>
		<td>User join a channel</td>
		<td>channel, nick, text, client, reply(txt)</td>
	</tr>
</table>

Change log
==========

### 2012-12-26 **v0.3.0** ###

* Bot completely rewritten (again)
* Temporary removing sugars in favor of prototype extensions
* Refinery lost in translation ;)
* Simpler code to do such simple things

### 2012-12-24 **v0.2.0** ###

* Bot completely rewritten in coffeescript on top of node and node-irc
* Fatbot is now a standalone framework
* Plugins are now called sugars
* Added sugars factories called refinery helpers
* Merge of node branch into master
* Fist beta working version of the coffeescript version