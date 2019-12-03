class CreateRegistrations < ActiveRecord::Migration[5.1]
  def change
    create_table      :registrations do |t|
      t.bigint        :user_id
      t.bigint        :chat_id
    end

    add_index :registrations, :user_id, unique: true
  end
end
