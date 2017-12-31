class CreateUpdates < ActiveRecord::Migration[5.1]
  def change
    create_table      :updates do |t|
      t.integer       :update_id
      t.timestamps
    end
  end
end
