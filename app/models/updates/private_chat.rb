require_relative 'chat'

module Updates
  class PrivateChat < Chat
    attr_reader :participant
    
    def self.register(update)
      chat = new(update)
      chat.active_participant? ?
        chat.parse_active :
        chat.parse_inactive
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
              send_message("Hurray!! " + Participant.message_set_prompt) :
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

    #### helpers
    def active_participant?
      !participant.nil?
    end
    def message_set?
      participant && participant.is_set?
    end
    def edit_message(text)
      participant.update(profile: text)
      edited_message = "You have successfully edited your personal description to:\n\n" +
        participant.profile
      send_message(edited_message)
    end
    def set_message
      participant.update(set: true)
      send_message("Hurray!! " + Participant.message_set_prompt)
      # TODO: shuffle and send preferences is done
    end
    def help_prompt
      Participant.short_help_prompt
    end

    private
    
    #### data
    def participant
      @participant ||= Participant.find_by_user_id(message.from.id)
    end
  end
end
