class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :standard,       null: false, default: ""
      t.string :unit,           null: false, default: ""
      t.float  :amount,         null: false, default: 0 
      t.float  :tax_unit_price, null: false, default: 0
      t.float  :tax_total,      null: false, default: 0
      t.float  :cess,           null: false, default: 0
      t.float  :tax_money,      null: false, default: 0 

      t.references :tax_category
      t.references :buyer

      t.timestamps null: false
    end
  end
end
