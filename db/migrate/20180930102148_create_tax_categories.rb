class CreateTaxCategories < ActiveRecord::Migration
  def change
    create_table :tax_categories do |t|
      t.string :name,       null: false, default: ""
      t.string :code,       null: false, default: ""

      t.references :user

      t.timestamps null: false
    end
  end
end
