class AddCategoryToChallenges < ActiveRecord::Migration[6.1]
  def change
    add_column :challenges, :category, :integer, default: 0
  end
end
