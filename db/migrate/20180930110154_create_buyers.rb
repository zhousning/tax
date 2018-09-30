class CreateBuyers < ActiveRecord::Migration
  def change
    create_table :buyers do |t|
      t.string :alias
      t.string :name
      t.string :duty_paragraph
      t.string :account
      t.string :phone

      t.references :user
      t.timestamps null: false
    end
  end
end
