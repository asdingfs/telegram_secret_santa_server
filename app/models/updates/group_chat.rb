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
      exhange && !exchange.is_set?
    end
    def registered?
      !!registration
    end
    def help_prompt
      # TODO: implement help_prompt
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
      if registered?
        exhange.participants.
          create!(user_id: message.from.id,
                  user_name: [message.from.first_name,
                              message.from.last_name].join(" "),
                  set: false)
        reply_message(exchange.participants_list_prompt)
      else
        # TODO: improve prompt, to register for participants
      end
    end
    def set_exchange
      exchange.update!(set: true)
      # send start message to participants
      exchange.participants.with_chat_id.each do |participant|
        send_message(participant.chat_id, Participant.start_prompt)
      end
      # TODO: improve prompt, reply to the group what should happen after setting exchanges
    end
  end
end
