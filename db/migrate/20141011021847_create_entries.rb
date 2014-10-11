class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.datetime :point_time
      t.float :point_value
      t.references :sequence, index: true

      t.timestamps
    end
  end
end
