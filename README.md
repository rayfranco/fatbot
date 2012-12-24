Fatbot
======

**NOTE : This README.md is used as specs for now. This is a draft with some ideas.**

Creating your bot
=================

* Create a file : `bots/mycoolbot.coffee`
* Import wanted sugars
* Configure it
* Add new actions (as sugars or built-in actions)
* Write test files
* Test it !
* Build it

Then from the `bin` directory, you can start your bot :

```bash
node coolbot.js
```

or

```bash
fatbot mycoolbot
```

You can pass arguments to your bot :

```bash
fatbot mycoolbot --server=freenode --channel=test --nickname=bender
```

Bot building
============

To make a compiled javascript executable file of your bot, use this task :

```coffeescript
bot:build 'hello'
```

Sugars
======

Sugars are behaviors. For example, saying hello to a user that connects to a channel.
Sugars are built on top of a refinery helper.

Here is a sugar on top of 'hear' built-in refinery helper that says hello to a user that says 'hello' :

```coffeescript
b.hear /hello/, (msg) ->
  msg.reply "Hello #{msg.author} !"
```

Refinery
========

The refinery is where helpers are stored, and used to easily create sugars.
A helper is pure logic, or can use high-level handlers structure.

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

Handlers
========

Handlers system is a high-level event manager that allows executing some callbacks on specific events and tests.

Events
======

These are the events thrown by the IRC interface (@account)

<table>
	<th>
		<td>Event name</td>
		<td>Description</td>
		<td>Parameters</td>
	</th>
	<tr>
		<td>self:connected</td>
		<td>Bot is connected to server</td>
		<td>{String server}</td>
	</tr>
	<tr>
		<td>self:talk</td>
		<td>Bot is talking</td>
		<td>{String author, String channel, Object account}</td>
	</tr>
	<tr>
		<td>self:join</td>
		<td>Bot is joining a channel</td>
		<td>{String channel, String username, Object message, Object account}</td>
	</tr>
	<tr>
		<td>user:talk</td>
		<td>User is talking in channel</td>
		<td>{String author, String channel, Object message, Object account}</td>
	</tr>
	<tr>
		<td>user:private</td>
		<td>User send pm to the bot</td>
		<td>{String author, String channel, Object message, Object account}</td>
	</tr>
	<tr>
		<td>user:join</td>
		<td>User join a channel</td>
		<td>{String channel, String username, Object message, Object account}</td>
	</tr>

</table>