```ascii
    ______      __  ____        __
   / ____/___ _/ /_/ __ )____  / /_
  / /_  / __ `/ __/ __  / __ \/ __/
 / __/ / /_/ / /_/ /_/ / /_/ / /_  
/_/    \__,_/\__/_____/\____/\__/  
```

FatBot is an easy to use and extensible ES6 IRC bot framework.

> Note: You are reading the documentation of the ES6 version (v1.x). If you are looking for the v0.3 documentation (`coffeescript`) please refer to the [0.3 branch](https://github.com/rayfranco/fatbot/tree/0.3).

Quick start
===========

## Install fatbot via npm

```bash
> npm install fatbot
```

## Create a file `bot.js`

```javascript
import { Bot } from 'fatbot'

let bot = new Bot({
  server: 'freenode',
  nick: 'fatbot',
  channels: ['#fatbot', '#skinnybot'],
  botDebug: false
})

// Listen to Bot events

bot.on('user:join', (r) => {
  r.reply "Welcome to #{r.channel}, #{r.nick} !"
})

// Listening discussion

bot.hear(/hello/, (r) => {
  r.reply(`Hello ${r.nick} !`)
})

// Connect the bot

bot.connect()
```

## Launch the bot

```bash
> fatbot bot.js
```

In this example, you are :

* Connecting `mybot` to a built-in server shortcut called `freenode` and join a channel called `#fatbot`
* Perform action on events with `Fatbot::on`
* Launching the bot with `Fatbot::connnect` method

> Note: Since your bot will be launched with babel-node you can write your bot in ES6

Organize your Bot
=================

For large bot projects, you may want to split your functionalities into different files.

You can use `Bot::on` with an object literal

```javascript
bot.on({
  event: 'user:talk',
  trigger: (r) => {
    console.log(`${r.nick} is talking...`)
  }
})
```

```javascript
// ./lib/hello.js
function callback (r) {
  r.reply(`Hello ${r.nick}!`)
}

export const ontalk = {
  event: 'user:talk',
  trigger: callback
}

export const onprivate = {
  event: 'user:private',
  trigger: callback
}
```

```javascript
// ./bot.js
import * as hello from './lib/hello'

//...

bot.on(hello)

bot.connect()
```

Extending the Bot
=================

You can extend the prototype of the `Bot` class. For example, the method `Bot::hear` is a built-in extension:

```javascript
Bot.prototype.hear = function (regex,callback) {
  this.on('user:talk', (r) => {
    if (r.text.match(regex)) {
      callback(r)
    }
  })
}
```

Events
======

You can easily add behaviors to the bot by listening to events :

```javascript
bot.on('user:join', (r) => {
  r.reply(`Welcome to ${r.channel}, ${r.nick}!`)
})
```

`r` is the Response object.

These are the events thrown by the bot.

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

### 2014-10-19 **v-1.0.0*** ###
* Rewrite the project into ES6. Nothing has changed in the API

### 2013-03-17 **v0.3.3** ###
* Fix CB when using coffee-script v.1.6.x compiler

### 2012-12-26 **v0.3.2** ###

* You can now add event listeners with objects literal
* You can now add event listeners bundled in arrays
* README.md upadated with new examples

### 2012-12-26 **v0.3.1** ###

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
