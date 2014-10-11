class AddUserIdToSequences < ActiveRecord::Migration
  def change
    add_column :sequences, :user_id, :integer, null: false
    add_index :sequences, :user_id
  end
end
