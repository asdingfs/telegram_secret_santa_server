module Updates
  class PrivateChat
    attr_reader :update

    # if does not exist, does not return any message. If exists, taken as preference
    def self.register(update)
      chat = new(update)
      chat.active_participant? ?
        chat.parse_active :
        chat.parse_inactive
    end
    def initialize(update)
      @update = update
    end

    ####################### methods
    def parse_active
      case
      when parser.multiple_commands?; parse_multiple_commands
      when parser.no_command?; parse_no_command
      else
        parser.commands.each do |command|
          case command
          when '/help'
            message_set? ?
              send_message("Yayy!! " + Participant.message_set_prompt) :
              send_message(Participant.long_help_prompt)
          when '/edit'
            message_set? ?
              send_message("Sorry! " + Participant.message_set_prompt) :
              edit_message(parser.non_commands)
          when '/set'
            set_message
          else
            message_set? ?
              send_message(Participant.message_set_prompt) :
              parse_no_command
          end
        end
      end
    end
    def parse_inactive
      case
      when parser.multiple_commands? || parser.no_command?
        send_message(Participant.not_registered_prompt)
      else
        parser.commands.each do |command|
          case command
          when '/start'
            send_message(Exchange.wrong_chat_prompt)
          else
            send_message(Participant.not_registered_prompt)
          end
          return
        end
      end
    end
    def parse_multiple_commands
      message = "Please send each commands one at a time. "\
        "I cannot parse all of them at once >.<. Please type /help if you need any assistance :)"
      send_message(message)
    end
    def parse_no_command
      message = "I'm very sorry that I am unable to recognize any valid commands. "\
        "Here's some /help for you:\n\n" +
        Participant.short_help_prompt
      send_message(message)
    end

    #### helpers
    def active_participant?
      !participant.nil?
    end
    def message_set?
      participant && participant.is_set?
    end
    def send_message(text)
      Sinatra::Application.settings.
        bot.api.send_message(chat_id: self.update.message.chat.id, text: text)
    end
    def edit_message(text)
      participant.update(profile: text)
      edited_message = "You have successfully edited your personal description to:\n\n" +
        participant.profile
      send_message(edited_message)
    end
    def set_message
      participant.update(set: true)
      send_message("Yayy! " + Participant.message_set_prompt)
      # TODO: shuffle and send preferences is done
    end
    #### data
    def participant
      @participant ||= Participant.find_by_user_id(self.update.message.from.id)
    end
    def parser
      @parser ||= Parser::BotCommand.new(self.update.message)
    end
  end
end
