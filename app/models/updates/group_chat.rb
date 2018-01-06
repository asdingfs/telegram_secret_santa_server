require_relative 'chat'

module Updates
  class GroupChat < Chat
    def self.register(update)
      chat = new(update)
      chat.parse
    end
    def parse
      case
      when parser.multiple_commands?; parse_multiple_commands
      when parser.no_command?; parse_no_command
      else; parse_command
      end
    end
    def parse_command
      case
      when set_exchange?; parse_set
      when exchange; parse_started # when started
      else; parse_idle # or else when idle or others
      end
    end
    def parse_set
      parser.commands.each do |command|
      end
    end
    def parse_started
      parser.commands.each do |command| 
      end
    end
    def parse_idle
      parser.commands.each do |command| 
      end
    end

    #### helpers
    def set_exchange? # individual participants filling in their preferences
      exchange && exchange.is_set?
    end

    private

    #### data
    def exchange
      @exchange ||= Exchange.find_by_chat_id(message.chat.id)
    end
  end
end
