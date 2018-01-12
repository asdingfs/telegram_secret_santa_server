require_relative 'chat'

module Updates
  class GroupChat < Chat
    def self.register(update)
      chat = new(update)
      chat.parse
    end
    def parse
      case
      when parser.multiple_commands?;     parse_multiple_commands
      when parser.no_command?;            parse_no_command
      else;                               parse_command
      end
    end
    def parse_command
      case
      when set_exchange?;                 parse_set
      when exchange;                      parse_started # when started, but not set
      else;                               parse_idle # or else when idle or others
      end
    end
    def parse_set
      parser.commands.each do |command|
        case command
        when '/help'
          reply_message(exchange.set_help_prompt)
        else
          # TODO: improve prompt
        end
      end
    end
    def parse_started
      parser.commands.each do |command|
        case command
        when '/help'
          reply_message(exchange.started_help_prompt)
        when '/join'
          join_exchange
        when '/set'
          set_exchange
        else
          # TODO: improve prompt
        end
      end
    end
    def parse_idle
      parser.commands.each do |command|
        case command
        when '/help'
          # TODO: improve prompt
        when '/start'
          create_exchange
        else
          reply_message(Exchange.idle_prompt)
        end
      end
    end

    #### helpers
    def set_exchange? # individual participants filling in their preferences
      exchange && exchange.is_set?
    end
    def started_exchange?
      exchange && !exchange.is_set?
    end
    def registered?
      !!registration
    end

    private

    #### data
    def exchange
      @exchange ||= Exchange.find_by_chat_id(message.chat.id)
    end
    def registration
      @registration ||= Registration.find_by_user_id(message.from.id)
    end
    def create_exchange
      @exchange = Exchange.
        create!(chat_id: message.chat.id,
                chat_title: message.chat.title,
                set: false)
      reply_message(Exchange.start_prompt)
    end
    def join_exchange
      full_name = [message.from.first_name,
                   message.from.last_name].join(" ")
      if registered?
        instance = Participant.
          where(user_id: message.from.id).
          first_or_initialize
        if instance.persisted?
          return reply_message(Participant.one_active_exchange_allowed_prompt(full_name)) unless
            instance.exchange_id == exchange.id # PENDING: test this scenario
        else
          instance.update!(exchange_id: exchange.id, user_name: full_name, set: false)
        end
        reply_message(exchange.participants_list_prompt)
      else
        reply_message(Participant.not_registered_prompt(full_name), # PENDING: add link by tg://user?id=#{message.from.id}
                      reply_to_message_id: message.message_id)
      end
    end
    def set_exchange
      exchange.update!(set: true)
      # send start message to participants
      exchange.participants.with_chat_id.each do |participant|
        send_message(participant.chat_id, Participant.start_prompt)
      end
      reply_message(Exchange.set_prompt)
    end
  end
end
