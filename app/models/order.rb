class Order < ActiveRecord::Base
  belongs_to :deal, touch: true #this is touching the deal every time someone makes an order on it, adding this so that we will be able to filter by "recently ordered"
  belongs_to :consumer

  # after_save :check_if_threshold_reached

  validates :consumer_id, uniqueness: { scope: :deal_id,
    message: "can only have one bid per deal." }

  private


end
