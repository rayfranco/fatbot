# Bot
NICK        = "FatYouth"
#CHANNELS    = ["#by-team","#by-news","#lol"]
CHANNELS    = ["#test"]

# Server
SERVER      = "192.168.0.202"
PORT        = 6667

# Services will test new stuff every
INTERVAL    = 600

# Services will send to
TWITTER_ST  = "#by-news"
INSTAGRAM_ST= "#by-news"

# Usernames
UID_TWITTER = "big_youth"
UID_INSTAGRAM = "agencebigyouth"

# API urls
TWITTER     = "http://api.twitter.com/1/statuses/user_timeline.xml?screen_name=" + UID_TWITTER
INSTAGRAM   = "http://widget.stagram.com/rss/n/" + UID_INSTAGRAM