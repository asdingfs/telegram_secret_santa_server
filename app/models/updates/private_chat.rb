module Updates
  class PrivateChat
    attr_reader :update

     # if does not exist, does not return any message. If exists, taken as preference
    def self.register(update)
      chat = new(update)
      if chat.active_participant?
        chat.parse
      else
        chat.send_message(Participant.not_registered_prompt)
      end
    end
    def initialize(update)
      @update = update
    end

    ####################### methods
    def parse
      parser.commands.each do |command|
        case command
        when '/start'
          send_message(Exchange.wrong_chat_prompt)
        end
      end
    end

    #### helpers
    def active_participant?
      id = self.update.message.from.id
      !Participant.find_by_user_id(id).nil?
    end
    def send_message(text)
      Sinatra::Application.settings.
        bot.api.send_message(chat_id: self.update.message.chat.id, text: text)
    end
    #### data
    def parser
      @parser ||= Parser::BotCommand.new(self.update.message.text, positions)
    end
    def bot_command_positions
      (self.update.message.entities || []).
        select    { |obj| obj.type == "bot_command" }.
        map       { |obj| [obj.offset, obj.length] }
    end
  end
end
