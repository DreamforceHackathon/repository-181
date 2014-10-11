class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.datetime :point_time, null: false
      t.float :point_value, null: false
      t.references :sequence, index: true

      t.timestamps
    end

    add_index :entries, :point_time
  end
end
