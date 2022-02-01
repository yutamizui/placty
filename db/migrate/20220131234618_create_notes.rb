class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.references :user
      t.string :title, null: false
      t.text :content

      t.timestamps
    end
  end
end
