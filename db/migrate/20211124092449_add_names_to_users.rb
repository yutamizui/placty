class AddNamesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :ja_name, :string
    add_column :users, :en_name, :string
  end
end
