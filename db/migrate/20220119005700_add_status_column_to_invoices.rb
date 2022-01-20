class AddStatusColumnToInvoices < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :status, :boolean, default: false
  end
end
