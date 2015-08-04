class OrdersController < ApplicationController
  before_action :set_consumer, only: [:index, :create, :edit, :update, :destroy]
  # before_action :set_deal, only: [:create]

  # before_action :check_threshold, only: [:create]

  def new
  end

  def create
    # if !threshold_met
    @order = Order.new(order_params)
      if @order.save
        redirect_to consumer_orders_path(@consumer), notice: "Order was successfully created"
      else
        flash[:notice] = 'You have already bid on this deal!'
        redirect_to :back
      end
    # end
  end

  def update
  end

  def index
    @orders = @consumer.orders.all
  end

  def edit
  end

  def show
    @order = Order.find(params[:id])
    if session[:consumer_id] == @order.consumer_id
    else
      redirect_to orders_path  
    end
  end

  def destroy
  end

  private

  def set_deal
    @deal = Deal.find(params[:deal_id])
  end

  def set_consumer
    @consumer = current_consumer
  end
  def order_params
    params.require(:order).permit(:consumer_id, :deal_id, :quantity)
  end
  def check_threshold
    if @deal.orders.count >= @deal.threshold
      threshold_met = true
    else
      threshold_met = false
    end
  end
end
