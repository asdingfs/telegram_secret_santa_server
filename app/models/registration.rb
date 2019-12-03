# this class stores a map from user ID to their personal chat ID,
# this is needed so that @GiftExchangeBot can personally private message users later on
# by default Telegram disallow bots to send messages to users which have not /start or /registered with the bot
class Registration < ActiveRecord::Base
  validates :user_id, presence: true, uniqueness: true
  validates :chat_id, presence: true
end
