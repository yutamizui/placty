class AddCompletedPercentageToReport < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :completed_percentage, :integer, default: 0
  end
end
