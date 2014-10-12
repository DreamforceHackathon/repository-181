class AddIgnoredToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :ignored, :boolean, default: false, null: false
  end
end
