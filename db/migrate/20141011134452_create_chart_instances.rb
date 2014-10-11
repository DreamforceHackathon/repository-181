class CreateChartInstances < ActiveRecord::Migration
  def change
    create_table :chart_instances do |t|
      t.attachment :image
      t.timestamps
    end
  end
end
