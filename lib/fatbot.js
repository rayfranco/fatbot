import fs from 'fs'
import irc from 'irc'
import sty from 'sty'
import events from 'events'

const defaults = {
  server: 'freenode',
  nick: 'fatbot',
  username: 'fatbot',
  realname: 'Fatbot, a coffeescript IRC bot',
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

export class Bot extends events.EventEmitter {
  /**
  Constructor
  **/

  constructor (settings, nick, channels) {
    const file = fs.readFileSync(`${__dirname}/../package.json`, 'utf-8')
    super()
    this.package = JSON.parse(file)

    if (typeof settings === 'string') {
      this.settings = {
        server: settings,
        nick,
        channels
      }
    } else {
      this.settings = Object.assign(defaults, settings)
    }

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
  Sugars event dispatcher // Unused for now
  **/

  dispatch (e, r) {
    sugars.forEach((sugar) => {
      if (sugar.listener === e) {
        sugar.callback(r)
      }
    })
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
    this.settings.server = this.settings.server in servers ? servers[this.settings.server] : this.settings.server

    this.client = new irc.Client(this.settings.server, this.settings.nick, {
      userName: this.settings.username,
      realName: this.settings.realname,
      port: this.settings.port,
      channels: this.settings.channels,
      autoConnect: false,
      autoRejoin: true
    })
  }

  prepEvents () {
    this.client.on('error', (err) => {
      return this.emit('client:error', err)
    })

    this.client.on('registered', (msg) => {
      return this.emit('self:connected', {
        server: msg.server
      })
    })

    this.client.on('message', (from, to, message) => {
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
    })

    this.client.on('pm', (from, text, message) => {
      return this.emit('user:private', {
        nick: from,
        text: text,
        client: this.client,
        reply: (txt) => {
          return this.say(txt, from)
        }
      })
    })

    this.client.on('join', (channel, nick, message) => {
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
    })
  }

  debug (n,d) {
    if (this.settings.botDebug) {
      console.log(`[${sty.bold('debug')}](${sty.red(sty.bold(n))}) ${sty.bold(d)}`)
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
      super.on(e, callback) // Is native syntax
    }
    else if (e.event != null && e.trigger != null) {
      this.on(e.event, e.trigger)  // Is object literal syntax
    }
    else {
      e.forEach((o) => {
        this.on(o)
      })
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
    console.log(`[${sty.bold(sty.green(version))}] I'm ${sty.bold(sty.cyan('loaded'))}, ready to connect !`)
  })
  this.on('self:connected', function (r) {
    console.log(`I'm connected to ${sty.green(sty.bold(r.server))}`)
  })
  this.on('self:join', function (r) {
    console.log(`I've just joined ${sty.yellow(r.channel)}`)
  })
  this.on('self:talk', function (r) {
    console.log(`[${sty.bold(sty.red(r.channel))}] ${sty.green(r.text)}`)
  })
  this.on('user:private', function (r) {
    console.log(`[${sty.bold(sty.red('private'))}] ${sty.green(r.nick)}: ${r.text}`)
  })
}

export default Bot
