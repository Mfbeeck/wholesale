class Deal < ActiveRecord::Base
  belongs_to :supplier
  has_many :orders
  has_many :comments


   def is_threshold_reached
    if orders.count >= threshold
    	true
    else
    	false
    end
  end

  private
end
