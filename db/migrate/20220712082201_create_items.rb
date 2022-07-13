class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name
      t.text :note
      t.integer :percentage
      t.references :challenge, foreign_key: true

      t.timestamps
    end
  end
end
