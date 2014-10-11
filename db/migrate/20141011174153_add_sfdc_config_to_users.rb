class AddSfdcConfigToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sfdc_config, :json
  end
end
