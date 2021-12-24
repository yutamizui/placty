class CreatePoints < ActiveRecord::Migration[6.1]
  def change
    create_table :points do |t|
      t.datetime :expired_at
      t.integer  :user_id
      t.boolean  :status, default: true

      t.timestamps
    end
  end
end
