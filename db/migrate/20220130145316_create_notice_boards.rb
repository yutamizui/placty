class CreateNoticeBoards < ActiveRecord::Migration[6.1]
  def change
    create_table :notice_boards do |t|
      t.references :language, foreign_key: true
      t.references :user, foreign_key: true
      t.text :note, null: false

      t.timestamps
    end
  end
end
