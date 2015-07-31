class Deal < ActiveRecord::Base
  belongs_to :supplier
  has_many :orders
end
