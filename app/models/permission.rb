# == Schema Information
#
# Table name: permissions
#
#  id            :integer          not null, primary key
#  name          :string
#  subject_class :string
#  subject_id    :integer
#  action        :string
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Permission < ActiveRecord::Base
  has_many :role_permissionships, :dependent => :destroy
  has_many :roles, :through => :role_permissionships
end
