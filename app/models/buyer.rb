# == Schema Information
#
# Table name: buyers
#
#  id             :integer          not null, primary key
#  alias          :string           default(""), not null
#  name           :string           default(""), not null
#  duty_paragraph :string           default(""), not null
#  account        :string           default(""), not null
#  phone          :string           default(""), not null
#  remark         :string           default(""), not null
#  checker        :string           default(""), not null
#  payee          :string           default(""), not null
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Buyer < ActiveRecord::Base
  has_many :invoices
  belongs_to :user
end
