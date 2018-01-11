class Registration < ActiveRecord::Base
  validates :user_id, presence: true, uniqueness: true
  validates :chat_id, presence: true
end
