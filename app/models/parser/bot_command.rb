module Parser
  class BotCommand
    def initialize(text, positions=[]) # positions are defined as an Array<Array<offset, length>>
      @text = text.is_a? String
      @positions = positions
    end
    def commands
      positions.map do |offset, length|
        text[offset, length].split("@").first
      end
    end
  end
end
