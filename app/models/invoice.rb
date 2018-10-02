# == Schema Information
#
# Table name: invoices
#
#  id               :integer          not null, primary key
#  standard         :string           default(""), not null
#  unit             :string           default(""), not null
#  amount           :float            default(0.0), not null
#  tax_unit_price   :float            default(0.0), not null
#  tax_total        :float            default(0.0), not null
#  cess             :float            default(0.0), not null
#  untax_unit_price :float            default(0.0), not null
#  untax_total      :float            default(0.0), not null
#  tax_money        :float            default(0.0), not null
#  tax_category_id  :integer
#  buyer_id         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Invoice < ActiveRecord::Base
  belongs_to :tax_category
  belongs_to :buyer
end
