import { Bot } from '../lib/fatbot'

let bot = new Bot({
  server: 'freenode',
  nick: 'fatbot',
  channels: ['#fatbot', '#skinnybot'],
  botDebug: false
})

// Listen to Bot events

bot.on('user:join', (r) => {
  r.reply(`Welcome to ${r.channel}, ${r.nick} !`)
})

// Extending bot prototype

Bot.prototype.hear = function(regex,callback) {
  this.on('user:talk', r => r.text.match(regex) && callback(r))
}

// Using newly created extensions

bot.hear(/hello/, (r) => {
  r.reply(`Hello ${r.nick} !`)
})

bot.hear(/bye/, (r) => {
  r.reply(`Good bye ${r.nick}`)
})

bot.connect()
