module Updates
  class Handler
    def self.handle(request)
      update = JSON.parse(request.body.read.to_s, object_class: OpenStruct)
      new(update).register
    end
    def initialize(update)
      @update = update
    end

    private
    
    def register
      case
      when update.chat.type == "private"
        PrivateChat.register(@update)
      when update.chat.type == "group"
        GroupChat.register(@update)
      end
    end
  end
end
