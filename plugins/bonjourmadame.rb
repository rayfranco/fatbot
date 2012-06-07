require 'open-uri'
require 'nokogiri'

BONJOURMADAME = "http://feeds.feedburner.com/BonjourMadame?format=xml"

module Plugins
  class Bonjourmadame
    include Cinch::Plugin
    set :react_on, :channel

    match /!bonjourmadame/i, method: :bonjourmadame
    def bonjourmadame(m)
      feed = Nokogiri::XML(open(BONJOURMADAME))
      sub = feed.css("channel > item").first
      m.reply "Bonjour Madame - %s" % [ 
        sub.css("link").inner_text.to_s
      ]
    end

  end
end