class OrdersController < ApplicationController
  before_action :set_consumer, only: [:index, :create, :edit, :update, :destroy]

  def new
  end

  def create
    @order = Order.new
    @order.consumer_id = current_consumer.id
    @order.deal_id = params[:deal_id]
    if @order.save
      #session[:supplier_id] = @supplier.id
      #redirect_to checkout_path(Deal.find(@order[:deal_id]))#, notice: "Order was successfully created"
      create_charge
    else
      render action: "new"
    end
  end

  def create_charge

    if @order.nil?
      create
    else

    p "***********************"
    p "This is Charges Controller #{Deal.find(current_consumer.orders.last[:deal_id]).price}"
    p "***********************"

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => Deal.find(current_consumer.orders.last[:deal_id]).price.to_i * 100,
      :description => 'Wholesale\'s Customer',
      :currency    => 'usd'
    )

    redirect_to consumer_orders_path(current_consumer)
    end
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path
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
