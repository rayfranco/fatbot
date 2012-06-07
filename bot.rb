#!/usr/bin/ruby

require 'rubygems'
require 'cinch'
require 'time'

# Server
SERVER      = "192.168.0.202"
PORT        = 6667
#CHANNELS    = ["#by-team","#by-news","#lol"]
CHANNELS    = ["#test"]

# Bot
NICK        = "FatYouth"
INTERVAL    = 600

# Send To
TWITTER_ST  = "#by-news"
INSTAGRAM_ST= "#by-news"

# Usernames
UID_TWITTER = "big_youth"
UID_INSTAGRAM = "agencebigyouth"

# API
TWITTER     = "http://api.twitter.com/1/statuses/user_timeline.xml?screen_name=" + UID_TWITTER
INSTAGRAM   = "http://widget.stagram.com/rss/n/" + UID_INSTAGRAM

# Plugins
$LOAD_PATH << "./plugins"
require 'twitter'
require 'lol'
require 'instagram'
require 'bonjourmadame'

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
      Plugins::Bonjourmadame
    ]
  end
end

bot.start