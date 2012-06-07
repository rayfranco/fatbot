#!/usr/bin/ruby

# Gems
require 'rubygems'
require 'cinch'
require 'time'

# Config
$LOAD_PATH << "./app"
require 'config.rb'

# Plugins
$LOAD_PATH << "./plugins"
require 'twitter'
require 'lol'
require 'instagram'
require 'bonjourmadame'
require 'lastseen'

# Bot
bot = Cinch::Bot.new do
  configure do |c|
  	c.nick = NICK
    c.server = SERVER
    c.channels = CHANNELS
    c.plugins.prefix = ''
    c.plugins.plugins = [
      Plugins::Twitter, 
      Plugins::Lol, 
      Plugins::Instagram,
      Plugins::Bonjourmadame,
      Plugins::LastSeen
    ]
  end
end

bot.start