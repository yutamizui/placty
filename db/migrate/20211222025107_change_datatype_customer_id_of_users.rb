class ChangeDatatypeCustomerIdOfUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :customer_id, :string
  end
end
