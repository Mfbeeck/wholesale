class Order < ActiveRecord::Base
  belongs_to :deal
  belongs_to :consumer

  # after_save :check_if_threshold_reached

  validates :consumer_id, uniqueness: { scope: :deal_id,
    message: "can only have one bid per deal." }



  private


end
