class AddReportIdToItems < ActiveRecord::Migration[6.1]
  def change
    add_reference :items, :report, foreign_key: true
  end
end
