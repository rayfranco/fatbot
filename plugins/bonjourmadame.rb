require 'open-uri'
require 'nokogiri'

BONJOURMADAME = "http://feeds.feedburner.com/BonjourMadame?format=xml"

module Plugins
  class Bonjourmadame
    include Cinch::Plugin
    set :react_on, :channel

    match /!(?:bonjourmadame|bjmd)(?: -?([rlh]|help))?/i, method: :bonjourmadame
    def bonjourmadame(m,param)
      feed = Nokogiri::XML(open(BONJOURMADAME))

      case param
        when nil,'l'
          sub = feed.css("channel > item").first
        when 'h','help'
          m.reply "!bjmd [-param] : Les parametres possibles sont r (random) ou l (last)"
        else
          subA = feed.css("channel > item").to_a
          sub = subA.sample
      end
      if (defined? sub)
        m.reply "Bonjour Madame - %s" % [ 
          sub.css("link").inner_text.to_s
        ]
      end
    end

  end
end