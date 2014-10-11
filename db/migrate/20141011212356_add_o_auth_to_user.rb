class AddOAuthToUser < ActiveRecord::Migration
  def change
    add_column :users, :sfdc_oauth_token, :text
    add_column :users, :sfdc_refresh_token, :text
    add_column :users, :sfdc_instance_url, :text
  end
end
