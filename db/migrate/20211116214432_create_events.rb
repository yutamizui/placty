class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :organizer
      t.string :title
      t.text :content
      t.datetime :date
      t.string :location
      t.integer :user_id

      t.timestamps
    end
  end
end
