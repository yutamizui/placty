class ChangeDataCompletedPercentageToReports < ActiveRecord::Migration[6.1]
  def change
    change_column :reports, :completed_percentage, :float
  end
end
