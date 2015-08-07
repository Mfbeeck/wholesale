class Consumer < ActiveRecord::Base
	has_secure_password
	has_many :orders
	has_many :comments
	validates :username, :email, :first_name, :address, :phone_number, presence: true
	validates :username, :email, uniqueness: true
	validates :password, length: { minimum: 7 }
	validates :phone_number, length: { is: 10 }
end
