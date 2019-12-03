class Update < ActiveRecord::Base
  validates_presence_of :update_id

  scope :old, -> { where(arel_table[:created_at].lt(DateTime.now - 1.day)) }
end
