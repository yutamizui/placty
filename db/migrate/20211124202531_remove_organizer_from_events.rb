class RemoveOrganizerFromEvents < ActiveRecord::Migration[6.1]
  def change
    remove_column :events, :organizer, :integer
  end
end
