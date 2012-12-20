Fatbot
======

** NOTE : This README.md is used as specs for now. This is a draft with some ideas. **

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
