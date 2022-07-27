class AddProgressToChallenges < ActiveRecord::Migration[6.1]
  def change
    add_column :challenges, :progress, :integer, default: 0
  end
end
