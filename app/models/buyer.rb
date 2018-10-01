# == Schema Information
#
# Table name: buyers
#
#  id             :integer          not null, primary key
#  alias          :string
#  name           :string
#  duty_paragraph :string
#  account        :string
#  phone          :string
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Buyer < ActiveRecord::Base
  has_many :invoices
  belongs_to :user
end
