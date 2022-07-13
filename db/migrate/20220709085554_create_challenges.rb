class CreateChallenges < ActiveRecord::Migration[6.1]
  def change
    create_table :challenges do |t|
      t.string :title
      t.string :target_user
      t.integer :author_id

      t.timestamps
    end
  end
end
