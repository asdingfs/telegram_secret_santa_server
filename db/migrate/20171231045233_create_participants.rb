class CreateParticipants < ActiveRecord::Migration[5.1]
  def change
    create_table    :participants do |t|
      t.references  :exchange
      t.text        :profile
    end
  end
end
