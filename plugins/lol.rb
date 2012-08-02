module Plugins
  class Lol
    include Cinch::Plugin
    set :react_on, :channel

    match /(salut|hello|bonjour|hey|yo|plop|yop|wesh) (FatYouth|Fat)/i, method: :sayhello
    def sayhello(m,msg)
      sentences = [
        "#{msg} #{m.user.nick}, bien ?",
        "#{msg} #{m.user.nick}, la forme ?",
        "Wesh #{m.user.nick}, ma couille, ca va ?",
        "Popopo ! #{m.user.nick} est dans la place !"
      ]
      m.reply sentences.sample
    end

    match /(?:.*FatYouth .*(sava|a va|vas tu).* ?)|(?:.*(a va|sava|vas tu).*FatYouth.* ?)/i, method: :sayhello2
    def sayhello2(m,msg)
      sentences = [
        "#{m.user.nick}, bah ecoute, ca va :)",
        "#{m.user.nick}, si si la famille toussa !",
        "#{m.user.nick}, tranquille...",
        "#{m.user.nick}, disons ca allait, jusqu'a ce que tu me parles..."
      ]
      m.reply sentences.sample
    end

    match /FatYouth .*(?:est|t\'es|tu es).* (\w+)/i, method: :stoi
    def stoi(m,msg)
      m.reply "#{m.user.nick} S'toi le #{msg}"
    end

    match /(?:(merci|thanks|thx) .*(FatYouth|Fat).*)|(?:FatYouth .*(merci|thanks|thx).*)/i, method: :derien
    def derien(m,msg)
      sentences = [
        "#{m.user.nick} no souci poto.",
        "#{m.user.nick} tkt !",
        "#{m.user.nick} np",
        "#{m.user.nick} de rien ;)"
      ]
      m.reply sentences.sample
    end

    match /(?:.*)(?:lol|kikoo|mdr|ptdr|haha|hoho|lfmao)(?:.*)/, method: :saylol
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

    # You should be online before 10, or after 12 !
    listen_to :join, method: :retard
    def retard(m)
      if (m.time.hour > 10 and m.time.hour < 12)
        m.reply "#{m.user.nick} c'est a cette heure-ci qu'on arrive ? Elles sont ou les chocolatines ?"
      end
    end

    match /(?:.*)pains? au chocolat(?:.*)/, method: :chocolatine
    def chocolatine(m)
      m.reply "#{m.user.nick} non, on dit bien chocolatine... Tu peux pas test."
    end
  end
end