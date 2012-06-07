require "time"

# TODO a permanent store, to keep messages even after a restart of the bot

  module Plugins
    class LastSeen
      include Cinch::Plugin

      LoggedMessage = Struct.new(:nick, :channel, :message, :time)

      def initialize(*args)
        super
        @logged_messages = {}
      end

      listen_to :channel, method: :log_message
      def log_message(m)
        return unless log_channel?(m.channel)
        @logged_messages[m.user.nick] = LoggedMessage.new(m.user.nick, m.channel.to_s, m.message, Time.now)
      end

      match(/seen (.+)/, method: :check_nick)
      def check_nick(m, nick)
        message = @logged_messages[nick]
        if message
          m.reply "I've last seen #{nick} at #{message.time} in #{message.channel} saying: #{message.message}", true
        else
          m.reply "I haven't seen #{nick}, sorry.", true
        end
      end

      private
      def log_channel?(channel)
        # we log a channel if:
        # - we have an explicit list of allowed channels and the
        #   channel is included
        # - we have an explicit list of disallowed channels and the
        #   channel is not included
        # - we don't have either list
        channel = channel.to_s
        our_config = config[:channels] || {}

        if our_config[:include]
          return our_config[:include].include?(channel)
        elsif our_config[:exclude]
          return !our_config[:exclude].include?(channel)
        else
          return true
        end
      end
    end
  end
