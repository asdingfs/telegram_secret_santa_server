class Exchange < ActiveRecord::Base
  has_many :participants, -> { with_chat_id },
    dependent: :destroy, inverse_of: :exchange

  validates :chat_id, presence: true, uniqueness: true
  validates :chat_title, presence: true
  validates :set, inclusion: { in: [true, false], }
  
  def conclude
    shuffle_hash.each do |gifter, giftee|
      send_message(gifter.chat_id, giftee.giftee_prompt)
    end
    self.destroy
  end
  def shuffle_hash
    participant_hash = self.participants.id_map
    participant_hash.keys.shuffle.each_with_index.map do |id, i|
      next_id = participant_ids[i + 1] || participant_ids[0]
      [id, next_id]
    end.map do |k, v|
      [participant_hash[k], participant_hash[v]] # { id => #participant }
    end.to_h
  end
  def finished?
    self.is_set? &&
      self.participants.where(set: false).empty?
  end

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
