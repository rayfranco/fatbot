#!/usr/bin/ruby

require 'rubygems'
require 'cinch'
require 'time'

# Server
SERVER      = "192.168.0.202"
PORT        = 6667
CHANNEL     = "#test"

# Bot
NICK        = "FatBot"
INTERVAL    = 10

# Usernames
UID_TWITTER = "rayfranco"
UID_INSTAGRAM = "rayfranco"

# API
TWITTER     = "http://api.twitter.com/1/statuses/user_timeline.xml?screen_name=" + UID_TWITTER
INSTAGRAM   = "http://widget.stagram.com/rss/n/" + UID_INSTAGRAM

# Plugins
$LOAD_PATH << "./plugins"
require 'twitter'
require 'lol'
require 'instagram'

bot = Cinch::Bot.new do
  configure do |c|
  	c.nick = NICK
    c.server = SERVER
    c.channels = [CHANNEL]
    c.plugins.prefix = ''
    c.plugins.plugins = [
      Plugins::Twitter, 
      Plugins::Lol, 
      Plugins::Instagram
    ]
  end
end

bot.start