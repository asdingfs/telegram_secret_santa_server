class CreateExchanges < ActiveRecord::Migration[5.1]
  def change
    create_table  :exchanges do |t|
      t.integer   :chat_id
      t.string    :chat_title
      t.boolean   :set, default: false
    end

    add_index :exchanges, :chat_id, unique: true
  end
end
