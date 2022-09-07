class AddTimeLimitToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :time_limit, :integer, default: 1, null: false
  end
end
