class AddActiveToSequences < ActiveRecord::Migration
  def change
    add_column :sequences, :active, :boolean, default: true
  end
end
