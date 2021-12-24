class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :customer_id, :integer
    add_column :users, :start_day, :datetime
  end
end
