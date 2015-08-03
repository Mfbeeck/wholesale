class Deal < ActiveRecord::Base
  belongs_to :supplier
  has_many :orders


   def is_threshold_reached
    if orders.count >= threshold
    	true
    else
    	false
    end
  end

  private
end
