class CreateLanguages < ActiveRecord::Migration[6.1]
  def change
    create_table :languages do |t|
      t.string :ja_name
      t.string :en_name

      t.timestamps
    end
  end
end
