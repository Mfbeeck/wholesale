class Deal < ActiveRecord::Base
  belongs_to :supplier
  has_many :orders
  has_many :comments
  has_one :winner

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

  def participants_left
    threshold - orders.count
  end

  private
end
