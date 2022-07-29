class ChangeDataTotalPercentageToReports < ActiveRecord::Migration[6.1]
  def change
    change_column :reports, :total_percentage, :float
  end
end
