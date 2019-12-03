class CreateUpdates < ActiveRecord::Migration[5.1]
  def change
    create_table      :updates do |t|
      t.bigint        :update_id, limit: 8
      t.timestamps
    end
  end
end
