class Exchange < ActiveRecord::Base
  has_many :participants

  validates :chat_id, presence: true, uniqueness: true
  validates :chat_title, presence: true
  validates :set, inclusion: { in: [true, false], }

  def self.idle_prompt
    "Hi, I'm GiftExchangeBot\n"\
      "To begin shuffling names for gift exhange, please type /start "
  end
  def self.wrong_chat_prompt
    "To start an exchange, please add me into a Telegram group, and type /start"
  end
end
