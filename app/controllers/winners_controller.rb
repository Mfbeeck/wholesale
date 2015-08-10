class WinnersController < ApplicationController
	
  def index
    @deal = Deal.find(params[:deal_id])
    @consumer_identify = Order.find(@deal.winning_order_id).consumer_id
    @consumer = Consumer.find(@consumer_identify)
    @supplier = current_supplier
  end

end