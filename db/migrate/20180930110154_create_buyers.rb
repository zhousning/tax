class CreateBuyers < ActiveRecord::Migration
  def change
    create_table :buyers do |t|
      t.string :alias,           null: false, default: ""
      t.string :name,            null: false, default: ""
      t.string :duty_paragraph,  null: false, default: ""
      t.string :account,         null: false, default: ""
      t.string :phone,           null: false, default: ""
      t.string :remark,          null: false, default: ""
      t.string :checker,         null: false, default: ""
      t.string :payee,           null: false, default: ""

      t.references :user
      t.timestamps null: false
    end
  end
end
