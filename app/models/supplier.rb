class Supplier < ActiveRecord::Base
  has_secure_password
  has_many :deals
  validates :username, :email, :company_name, presence: true
  validates :username, :email, uniqueness: true
end
