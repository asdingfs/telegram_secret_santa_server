class Participant < ActiveRecord::Base
  belongs_to :exchange

  validates_uniqueness_of :user_id
  validates_inclusion_of :is_set, in: [true, false]

  def self.not_registered_prompt
    "Sorry, you are currently not participating in any exchanges. " +
      Exchange.wrong_chat_prompt
  end
end
