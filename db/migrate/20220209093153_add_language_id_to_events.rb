class AddLanguageIdToEvents < ActiveRecord::Migration[6.1]
  def change
    add_reference :events, :language, foreign_key: true
  end
end
