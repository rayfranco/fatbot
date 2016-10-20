import { readFileSync } from 'fs'
import { EventEmitter } from 'events'
import { Client } from 'irc'
import path from 'path'
import colors from 'colors'

const defaults = {
  server: 'freenode',
  nick: 'fatbot',
  username: 'fatbot',
  realname: 'Fatbot, an ES6 IRC bot',
  port: 6667,
  channels: ['#fatbot'],
  autoConnect: false,
  botDebug: false
}

const servers = {
  dalnet: 'irc.dal.net',
  efnet: 'irc.efnet.net',
  freenode: 'irc.freenode.net',
  mozilla: 'irc.mozilla.org',
  quakenet: 'irc.quakenet.org',
  undernet: 'us.undernet.org'
}

export class Bot extends EventEmitter {
  /**
  Constructor
  **/

  constructor (settings, nick, channels) {
    super()

    const file = readFileSync(path.join(__dirname, '../package.json'), 'utf-8')

    this.package = JSON.parse(file)

      this.settings = typeof settings === 'string' ? {
        server: settings,
        nick,
        channels
      } : Object.assign(defaults, settings)

    this.prepClient()
    this.prepEvents()
    this.loadExtensions()

    this.emit('self:start', {
      client: this.client
    })
  }

  toString () {
    return `${this.package.name}/${this.package.version} node/${process.versions.node}`
  }

  /**
  Connect the client
  **/

  connect () {
    this.client.connect()
  }

  /**
  Configure client and Events handlers
  **/

  prepClient () {
    var s = this.settings

    s.server = s.server in servers ? servers[s.server] : s.server

    this.client = new Client(s.server, s.nick, {
      userName: s.username,
      realName: s.realname,
      port: s.port,
      channels: s.channels,
      autoConnect: false,
      autoRejoin: true
    })
  }

  prepEvents () {
    const events = {
      error (err) {
        this.emit('client:error', err)
      },
      registered (msg) {
        this.emit('self:connected', {
          server: msg.server
        })
      },
      message (from, to, message) {
        if (to !== this.settings.nick) {
          return this.emit('user:talk', {
            nick: from,
            channel: to,
            text: message,
            client: this.client,
            reply: (txt) => {
              return this.say(txt, to)
            }
          })
        }
      },
      pm (from, text, message) {
        return this.emit('user:private', {
          nick: from,
          text: text,
          client: this.client,
          reply: (txt) => {
            return this.say(txt, from)
          }
        })
      },
      join (channel, nick, message) {
        if (nick === this.settings.nick) {
          return this.emit('self:join', {
            channel: channel,
            nick: nick,
            text: message,
            client: this.client
          })
        } else {
          return this.emit('user:join', {
            channel: channel,
            nick: nick,
            text: message,
            client: this.client,
            reply: (txt) => {
              return this.say(txt, channel)
            }
          })
        }
      }
    }

    for (let event in events) {
      this.client.on(event, events[event].bind(this))
    }
  }

  debug (n,d) {
    if (this.settings.botDebug) {
      console.log(`[${'debug'.bold}](${n.bold.red}) ${d.bold}`)
    }
  }

  // This is temporary, do not use
  loadExtensions () {}

  emit (e, ...params) {
    super.emit(e, ...params)
    if (e !== '*') {
      this.emit('*', e, ...params)
    }
  }

  /**
  Catch all events
  **/

  on (e, callback) {
    if (typeof e === 'string') {
      console.log('listen to ', e, callback)
      super.on(e, callback) // Is native syntax
    }
    else if (e.event != null && e.trigger != null) {
      this.on(e.event, e.trigger)  // Is object literal syntax
    }
    else if (typeof e === 'array'){
      e.forEach((o) => {
        this.on(e, o)
      })
    }
    else if (typeof e === 'object') {
      for (var o in e) {
        this.on(e[o])
      }
    }
  }

  /**
  IRC basic interface
  **/

  say (text, channel) {
    if (channel != null) {
      this.client.say(channel, text)
      this.emit('self:talk', {
        channel,
        text,
        client: this.client
      })
    }
    else {
      this.channels.forEach((channel) => {
        this.emit('self:talk', {
          channel,
          text,
          client: this.client
        })
        this.client.say(channel, text)
      })
    }
  }

  leave (channel, callback) {
    if (this.channels.indexOf(channel) > -1)  {
      this.client.part(channel, callback)
      this.channels.pop(channel)
    }
  }

  join (channel, callback) {
    this.client.join(channel, callback)
    this.chanels.push(channel)
  }
}


/**
Built-in extensions
**/

Bot.prototype.hear = function (regex,callback) {
  this.on('user:talk', (r) => {
    if (r.text.match(regex)) {
      callback(r)
    }
  })
}

Bot.prototype.loadExtensions = function () {
  if (this.settings.botDebug) {
    this.on('*', function (e,r) {
      this.debug(e, r)
    })
  }
  this.on('self:start', function () {
    let version = this.toString()
    console.log(`[${version.bold.green}] I'm ${'loaded'.bold.cyan}, ready to connect !`)
  })
  this.on('self:connected', function (r) {
    console.log(`I'm connected to ${r.server.bold.green}`)
  })
  this.on('self:join', function (r) {
    console.log(`I've just joined ${r.channel.yellow}`)
  })
  this.on('self:talk', function (r) {
    console.log(`[${r.channel.bold.red}] ${r.text.green}`)
  })
  this.on('user:private', function (r) {
    console.log(`[${'private'.bold.red}] ${r.nick.green}: ${r.text}`)
  })
}

export default Bot
