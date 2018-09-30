# == Schema Information
#
# Table name: invoices
#
#  id             :integer          not null, primary key
#  standard       :string
#  unit           :string
#  amount         :float
#  tax_unit_price :float
#  tax_total      :float
#  cess           :float
#  tax_money      :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Invoice < ActiveRecord::Base
  belongs_to :tax_category
  belongs_to :buyer
end
