class AddLimitNumberToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :limit_number, :integer, default: 1, null: false
  end
end
