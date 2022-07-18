class AddTargetDateToReports < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :target_date, :datetime
  end
end
