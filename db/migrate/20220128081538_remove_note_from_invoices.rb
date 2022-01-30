class RemoveNoteFromInvoices < ActiveRecord::Migration[6.1]
  def change
    remove_column :invoices, :note, :text
  end
end
