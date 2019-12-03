require_relative 'chat'

module Updates
  class PrivateChat < Chat
    attr_reader :participant
    
    def self.register(update)
      chat = new(update)
      chat.parse
    end
    def parse
      case
      when parser.multiple_commands?;   parse_multiple_commands
      when parser.no_command?;          nil # ignore & do nothing
      else;                             parse_command
      end
    end
    def parse_command
      case
      when set_message?;                parse_set
      when participant;                 parse_active
      else;                             parse_inactive
      end
    end

    ####################### methods
    def parse_set
      parser.commands.each do |command|
        reply_message("Sorry! " + Participant.message_set_prompt) # TODO: improve prompt
      end
    end
    def parse_active
      parser.commands.each do |command|
        case command
        when '/help'
          reply_message(Participant.long_help_prompt)
        when '/edit'
          edit_message(parser.non_commands)
        when '/set'
          set_message
        when '/unset'
          unset_message
        else
          # TODO:
        end
      end
    end
    def parse_inactive
      parser.commands.each do |command|
        case command
        when '/register'
          register_participant
        else
          reply_message(Participant.inactive_exchange_prompt)
        end
      end
    end

    #### helpers
    def active_participant?
      !participant.nil?
    end
    def set_message?
      participant && participant.is_set?
    end
    def edit_message(text)
      participant.update(profile: text)
      edited_message = "You have successfully edited your personal description to:\n\n" +
        participant.profile
      reply_message(edited_message)
    end
    def set_message
      participant.update!(set: true)
      reply_message("Hurray!! " + Participant.message_set_prompt)
      if exchange.finished?
        exchange.shuffled_participants_pair.each do |gifter, giftee|
          send_message(gifter.chat_id, giftee.giftee_prompt)
        end
        exchange.destroy!
      end
    end
    def unset_message
      participant.update!(set: false)
      reply_message(Participant.message_unset_prompt)
    end
    def register_participant
      registration = Registration.
        where(user_id: message.from.id).
        first_or_initialize
      registration.update!(chat_id: message.chat.id)
      reply_message(Participant.register_prompt)
    end
    def help_prompt
      Participant.short_help_prompt
    end

    private
    
    #### data
    def participant
      @participant ||= Participant.find_by_user_id(message.from.id)
    end
    def exchange
      @exchange ||= (participant && participant.exchange)
    end
  end
end
