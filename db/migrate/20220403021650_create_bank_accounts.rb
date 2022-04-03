class CreateBankAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :bank_accounts do |t|
      t.string :email
      t.string :account_holder
      t.string :institution_number
      t.string :transit_number
      t.string :ach_routing_number
      t.string :bsb_code
      t.string :uk_sort_code
      t.string :bank_name
      t.string :branch_name
      t.integer :account_type
      t.string :account_number
      t.string :iban
      t.integer :currency
      t.string :country_name
      t.string :city_name
      t.string :recipient_address
      t.string :post_code
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
