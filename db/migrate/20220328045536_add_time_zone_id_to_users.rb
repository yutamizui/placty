class AddTimeZoneIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :time_zone_id, :string
  end
end
