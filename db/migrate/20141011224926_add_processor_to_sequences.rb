class AddProcessorToSequences < ActiveRecord::Migration
  def change
    add_column :sequences, :processor, :string
  end
end
