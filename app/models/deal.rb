class Deal < ActiveRecord::Base
  belongs_to :supplier
  has_many :orders
  has_many :comments

  validates :name, :url, :description, :price, :threshold, :product_type, presence: true


   def is_threshold_reached
    if orders.count >= threshold
    	true
    else
    	false
    end
  end

  def has_exceeded_threshold?
    orders.count >= threshold
  end

  private
end
