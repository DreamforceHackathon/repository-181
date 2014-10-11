class AddTypeToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :source, :string, default: "automatic", null: false
  end
end
