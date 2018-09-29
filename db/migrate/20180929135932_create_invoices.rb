class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :standard,       null: false, default: ""
      t.string :unit,           null: false, default: ""
      t.string :amount,         null: false, default: ""
      t.string :tax_unit_price, null: false, default: ""
      t.string :tax_total,      null: false, default: ""
      t.string :cess,           null: false, default: ""
      t.string :tax_money,      null: false, default: ""

      t.timestamps null: false
    end
  end
end
