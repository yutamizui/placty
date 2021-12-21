class AddColumnToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :length, :integer
    add_column :events, :price, :integer
  end
end