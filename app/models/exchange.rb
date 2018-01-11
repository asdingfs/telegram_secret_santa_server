class Exchange < ActiveRecord::Base
  has_many :participants, -> { with_chat_id }

  validates :chat_id, presence: true, uniqueness: true
  validates :chat_title, presence: true
  validates :set, inclusion: { in: [true, false], }

  # prompts
  def self.idle_prompt
    "Hi, I'm GiftExchangeBot\n"\
      "To begin shuffling names for gift exhange, please type /start "
  end
  def self.wrong_chat_prompt
    "To start an exchange, please add me into a Telegram group, and type /start"
  end
  def self.start_prompt
    "Let's list down the participants for this exchange now. "\
      "Please type /join to join this exchange.\n\n"\
      "Here are some usable commands:\n\n" +
      started_help_prompt
  end
  def self.started_help_prompt
    "Commands:\n\n"\
      "/help          - display a more descriptive command list (this list of commands)\n"\
      "/join          - user who type this while Exchange is started would be included in the exchange list\n"\
      "/set           - locks the joined user, "\
      "/cancel        - cancel the exchange"
  end
end
