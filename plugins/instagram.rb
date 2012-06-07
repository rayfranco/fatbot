require 'open-uri'
require 'nokogiri'

module Plugins
  class Instagram
    include Cinch::Plugin
    set :react_on, :channel

    timer INTERVAL, method: :updatefeed
    def updatefeed
      feed = Nokogiri::XML(open(INSTAGRAM))
      sub = feed.css("item").first
      new = sub.css("pubDate").inner_text.to_s
      if defined? @old
        printnew(sub) unless new == @old
      else
        printnew(sub)
      end
      @old = new
    end

    def printnew(entry)
      Channel(CHANNEL).send "%s - %s" % [ 
        entry.css("title").inner_text,
        entry.css("image > link").inner_text.to_s
      ]
    end
  end
end