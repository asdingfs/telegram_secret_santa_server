class CreateExchanges < ActiveRecord::Migration[5.1]
  def change
    create_table  :exchanges do |t|
      t.integer   :chat_id
      t.string    :chat_title
      t.boolean   :is_set
    end
  end
end
