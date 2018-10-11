# == Schema Information
#
# Table name: system_infos
#
#  id                   :integer          not null, primary key
#  version              :string           default("2.0"), not null
#  national_tax_version :string           default("3.0"), not null
#  tax_category_version :string           default("30.0"), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class SystemInfo < ActiveRecord::Base
end
