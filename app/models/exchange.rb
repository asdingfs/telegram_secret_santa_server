class Exchange < ActiveRecord::Base
  has_many :participants, -> { with_chat_id },
    dependent: :destroy, inverse_of: :exchange

  # this refers to the group chat ID
  validates :chat_id, presence: true, uniqueness: true
  validates :chat_title, presence: true
  validates :set, inclusion: { in: [true, false] }

  # return shuffled participants in nested array format
  # ensure that there is no duplicate in gifter and giftee
  #
  # for example, if there are 3 participants P1, P2, and P3
  # output is:
  #   [
  #     [P2, P1],
  #     [P1, P3],
  #     [P3, P2]
  #   ]
  def shuffled_participants_pair
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
      self.participants.unset.empty?
  end
  def is_set?
    self.set
  end

  # prompts
  def self.idle_prompt
    "Hi, I'm GiftExchangeBot\n"\
      "To begin shuffling names for gift exchange, please type /start "
  end
  def self.wrong_chat_prompt
    "To start an exchange, please add me into a Telegram group, and type /start"
  end
  def self.start_prompt
    "Woohoo! You've started an exchange!\n"\
      "Let's list down the participants for this exchange now.\n"\
      "Please type /join to participate in this exchange.\n\n" +
      started_help_prompt
  end
  def self.started_help_prompt
    "Exchange status:\nSTARTED (Gathering participants)\n\n"\
      "Commands:\n\n"\
      "/help - display a more descriptive command list (this list of commands)\n"\
      "/join - user who type this while Exchange is started would be included in the exchange list\n"\
      "/set - locks the joined user,\n"\
      "/cancel - cancel the exchange"
  end
  def self.set_prompt
    "Thank you, the exchange participants have been set!\n\n"\
      "I will now PM each of the participants to enter some details about themselves, "\
      "and ultimately the giftee name for the participants later."
  end
  def set_help_prompt
    "Exchange status:\nSET (Gathering participants' interest)\n\n"\
      "Sit back, relax, and keep on giving to others :)\n"\
      "There is nothing more you could do in this group."
  end
  def started_help_prompt
    self.class.started_help_prompt +
      "#{participants_list_prompt}\n\n"\
  end
  def participants_list_prompt
    "Participants:\n#{(participants_list || 'None')}"
  end
  def participants_list
    i = 0
    participants.map do |participant|
      i += 1
      "#{i}. #{participant.user_name}"
    end.join("\n")
  end
end
