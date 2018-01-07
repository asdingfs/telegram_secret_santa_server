module Updates
  class Chat < Struct.new(:update)
    attr_reader :parser
    
    def self.register(update)
      # INTERFACE: to implement
    end
    
    def send_message(text)
      Sinatra::Application.settings.bot.api.
        send_message(chat_id: message.chat.id, text: text)
    end

    def message
      self.update.message
    end
    
    def parse_no_command
      msg = "I'm very sorry that I am unable to recognize any valid commands. "
      msg += "Here's some /help for you:\n\n" + help_prompt unless help_prompt.blank?
      send_message(msg)
    end
    def parse_multiple_commands
      send_message("Please send each commands one at a time. "\
                   "Sorry, I cannot parse all of them at once. Please type /help if you need any assistance :)")
    end

    def help_prompt
      # INTERFACE: to implement
      ""
    end
    
    def parser
      @parser ||= Parser::BotCommand.new(message)
    end
  end
end
