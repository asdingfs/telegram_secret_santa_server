module Updates
  class Handler
    attr_reader :update
    
    def self.handle(request)
      update = JSON.parse(request.body.read.to_s, object_class: OpenStruct)
      new(update).process
    end
    def initialize(update)
      @update = update
    end
    
    def process
      id = self.update.update_id
      ActiveRecord::Base.transaction do
        if Update.find_by_update_id(id).nil?
          case self.update.message.chat.type
          when 'private'
            PrivateChat.register(self.update)
          when 'group'
            GroupChat.register(self.update)
          end
          Update.create!(update_id: id)
        else
          puts "Update with ID: #{id} has already been registered! Skipping..."
        end
      end
      self
    end
  end
end
