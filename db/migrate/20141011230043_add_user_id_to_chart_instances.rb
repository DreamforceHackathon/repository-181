class AddUserIdToChartInstances < ActiveRecord::Migration
  def change
    add_column :chart_instances, :user_id, :integer, null: false
    add_index :chart_instances, :user_id
  end
end
