class Exchange < ActiveRecord::Base
  has_many :participants

  validates_presence_of :chat_id, :chat_title
  validates_inclusion_of :is_set, in: [true, false]
end
