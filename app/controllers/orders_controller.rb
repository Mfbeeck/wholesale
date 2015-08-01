class OrdersController < ApplicationController

  def new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      #session[:supplier_id] = @supplier.id
      redirect_to :back, notice: "Order was successfully created"
    else
      render action: "new"
    end
  end

  def update
  end

  def index
    @orders = Order.all
  end

  def edit
  end

  def show
  end

  def destroy
  end

  private

  def order_params
    params.require(:order).permit(:consumer_id, :deal_id, :quantity)
  end

end
