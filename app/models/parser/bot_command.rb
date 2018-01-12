module Parser
  class BotCommand
    attr_accessor :message, :text, :positions
    
    def initialize(message) # positions are defined as an Array<Array<offset, length>>
      @message = message
      @text = message.text
    end
    def raw_commands # still includes /start@GiftExchangeBot for example
      positions.map do |offset, length|
        text[offset, length].strip
      end
    end
    def commands # remove /start@GiftExchangeBot to take only the first /start command, clean data
      raw_commands.map do |string|
        string.split("@").first.strip.downcase
      end
    end
    def non_commands # and remove spaces around it too
      string = raw_commands.map { |c| Regexp.quote(c) }.join("|")
      pattern = Regexp.new("(#{string})[ ]*")
      text.gsub(pattern, '').strip
    end
    def multiple_commands?
      commands.count > 1
    end
    def no_command?
      commands.count == 0
    end

    private

    def positions
      (self.message.entities || []).
        select    { |obj| obj.type == "bot_command" }.
        map       { |obj| [obj.offset, obj.length] }
      end
    end
  end
