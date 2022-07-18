class AddStatusToChallenges < ActiveRecord::Migration[6.1]
  def change
    add_column :challenges, :status, :integer, default: 0
    add_column :challenges, :deadline, :datetime
  end
end
