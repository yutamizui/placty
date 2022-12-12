class CreateDayFrames < ActiveRecord::Migration[6.1]
  def change
    create_table :day_frames do |t|
      t.references :challenge, foreign_key: true
      t.integer :day

      t.timestamps
    end
  end
end
