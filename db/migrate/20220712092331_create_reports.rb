class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.references :challenge, foreign_key: true
      t.references :user, foreign_key: true
      t.string :completed_item

      t.timestamps
    end
  end
end
