class CreateSystemInfos < ActiveRecord::Migration
  def change
    create_table :system_infos do |t|
      t.string :version, :null => false, :default => "2.0"
      t.string :national_tax_version, :null => false, :default => "3.0"
      t.string :tax_category_version, :null => false, :default => "30.0"

      t.timestamps null: false
    end
  end
end
