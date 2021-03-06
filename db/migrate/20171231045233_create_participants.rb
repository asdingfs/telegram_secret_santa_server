class CreateParticipants < ActiveRecord::Migration[5.1]
  def change
    create_table    :participants do |t|
      t.references  :exchange
      t.bigint      :user_id
      t.string      :user_name
      t.text        :profile
      t.boolean     :set, default: false
    end

    add_index :participants, :user_id, unique: true
  end
end
