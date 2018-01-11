class CreateRegistrations < ActiveRecord::Migration[5.1]
  def change
    create_table      :registrations do |t|
      t.integer       :user_id
      t.integer       :chat_id
    end

    add_index :registrations, :user_id, unique: true
  end
end
