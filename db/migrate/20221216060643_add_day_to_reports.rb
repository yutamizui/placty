class AddDayToReports < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :day, :integer, default: 0, null: false
  end
end
