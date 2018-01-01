class Participant < ActiveRecord::Base
  belongs_to :exchange

  validates_uniqueness_of :user_id
end
