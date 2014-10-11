class AddSfdcSetupToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sfdc_setup, :boolean, default: false
  end
end
