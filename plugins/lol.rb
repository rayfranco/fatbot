module Plugins
  class Lol
    include Cinch::Plugin
    set :react_on, :channel

    match /(salut|hello|bonjour|hey|yo|plop) FatYouth/i, method: :sayhello
    def sayhello(m,msg)
      sentences = [
        "#{msg} #{m.user.nick}, bien ?",
        "#{msg} #{m.user.nick}, la forme ?",
        "Wesh #{m.user.nick}, ma couille, ca va ?",
        "Popopo ! #{m.user.nick} est dans la place !"
      ]
      m.reply sentences.sample
    end

    match /(?:.*)lol(?:.*)/, method: :saylol
    def saylol(m)
      sentences = [
        "Quel blagueur ce #{m.user.nick} ! lol",
        "#{m.user.nick} lol",
        "Hahaha #{m.user.nick} trop lol",
        "#{m.user.nick} LOL http://www.youtube.com/watch?v=oHg5SJYRHA0",
        "#{m.user.nick} Allez, viens lol http://www.youtube.com/watch?v=5SIQPfeUTtg"
      ]
      m.reply sentences.sample
    end
  end
end