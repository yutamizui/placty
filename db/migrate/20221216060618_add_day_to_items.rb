class AddDayToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :day, :integer, default: 0, null: false
  end
end
