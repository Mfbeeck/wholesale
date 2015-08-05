class Consumer < ActiveRecord::Base
	has_secure_password
	has_many :orders
	has_many :comments
end
