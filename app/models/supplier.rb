class Supplier < ActiveRecord::Base
  has_secure_password
  has_many :deals
end
