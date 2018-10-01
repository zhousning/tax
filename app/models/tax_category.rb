# == Schema Information
#
# Table name: tax_categories
#
#  id         :integer          not null, primary key
#  name       :string           default(""), not null
#  code       :string           default(""), not null
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TaxCategory < ActiveRecord::Base
  has_many :invoices
  belongs_to :user
end
