# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  role_id                :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  rolify
  has_many :buyers
  has_many :tax_categories
  
  belongs_to :role

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #不要将assign_default_role放在rolify之前,不然会被执行两次
  after_create :assign_default_role

  def super_admin?
    self.has_role? Setting.roles.super_admin
  end

  def set_roles(roles)
    self.roles = Role.where(:id => roles)
  end

  def assign_default_role
    self.add_role Setting.roles.buyer
    self.add_role Setting.roles.tax_category
    self.add_role Setting.roles.invoice
  end
end
