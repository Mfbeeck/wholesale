class Consumer < ActiveRecord::Base
	has_secure_password
	has_many :orders
	has_many :comments
	validates :username, :email, :first_name, :address, :phone_number, presence: true
	validates :username, :email, uniqueness: true
	validates :password, presence: true, on: :create
	validates :phone_number, length: { is: 10 }

	# HOW TO MAKE A CUSTOM VALIDATION
	# validate :check_length
 	# def check_length
	 #    unless phone_number.size == 10
	 #      errors.add(:phone_number, "must be 10 digits") 
	 #    end
  # 	end
end
