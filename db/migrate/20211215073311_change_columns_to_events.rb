class ChangeColumnsToEvents < ActiveRecord::Migration[6.1]
  def change
    change_column :events, :length, :integer, default: 10
    change_column :events, :point, :integer, default: 0
  end
end
