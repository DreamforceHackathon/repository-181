class CreateSequences < ActiveRecord::Migration
  def change
    create_table :sequences do |t|
      t.string :title, null: false
      t.timestamps
    end
  end
end
