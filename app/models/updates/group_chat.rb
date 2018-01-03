module Updates
  class GroupChat
    def self.register(update)
      Sinatra::Application.settings.
        bot.api.send_message(chat_id: update.message.chat.id,
                             text: Exchange.idle_prompt)
    end
  end
end
