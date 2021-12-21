class RenamePriceToPoints < ActiveRecord::Migration[6.1]
  def change
    rename_column :events, :price, :point
  end
end
