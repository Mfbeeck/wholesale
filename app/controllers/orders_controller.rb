class OrdersController < ApplicationController
  before_action :set_consumer, only: [:index, :create, :edit, :update, :destroy]

  def new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      #session[:supplier_id] = @supplier.id
      redirect_to consumer_orders_path(@consumer), notice: "Order was successfully created"
    else
      render action: "new"
    end
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

  def set_consumer
    @consumer = current_consumer
  end
  def order_params
    params.require(:order).permit(:consumer_id, :deal_id, :quantity)
  end

end
