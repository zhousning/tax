class TaxCategory < ActiveRecord::Base
  has_many :invoices
  belongs_to :user
end
