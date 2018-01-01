class CreateParticipants < ActiveRecord::Migration[5.1]
  def change
    create_table    :participants do |t|
      t.references  :exchange
      t.integer     :user_id
      t.text        :profile
      t.boolean     :is_set
    end

    add_index :participants, :user_id, unique: true
  end
end
