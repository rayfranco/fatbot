require 'open-uri'
require 'nokogiri'

module Plugins
  class Twitter
    include Cinch::Plugin
    set :react_on, :channel

    timer INTERVAL, method: :updatefeed
    def updatefeed
      feed = Nokogiri::XML(open(TWITTER))
      sub = feed.css("status").first
      new = sub.css("id").inner_text.to_s
      if defined? @old
        printnew(sub) unless new == @old
      else
        printnew(sub)
      end
      @old = new
    end

    def printnew(entry)
      Channel(TWITTER_ST).send "@%s: %s" % [ 
        entry.css("user > screen_name").inner_text,
        entry.css("text").inner_text
      ]
    end
  end
end