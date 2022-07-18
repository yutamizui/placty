class AddTotalPercentageToReport < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :total_percentage, :integer, default: 0
  end
end
