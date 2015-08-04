class OrdersController < ApplicationController
  before_action :set_consumer, only: [:index, :create, :edit, :update, :destroy]
  before_action :set_order, only: [:edit, :update]
  before_action :set_deal, only: [:edit, :update]
  before_action :check_if_still_active, only: [:edit]
  # before_action :set_deal, only: [:create]

  # before_action :check_threshold, only: [:create]

  def new
  end

  def create
    @order = Order.new
    @order.consumer_id = current_consumer.id
    @order.deal_id = params[:deal_id]
    @order.address = current_consumer.address
    if @order.save
      #session[:supplier_id] = @supplier.id
      #redirect_to checkout_path(Deal.find(@order[:deal_id]))#, notice: "Order was successfully created"
      create_charge
    else
      flash[:notice] = 'You have already bid on this deal!'
      redirect_to :back
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
    redirect_to edit_consumer_order_path(current_consumer, @order)

    end
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path
  end

  def update
      respond_to do |format|
        if @order.update(order_params)
          format.html { redirect_to order_path(@order)}
          format.json { render :show, status: :ok, location: current_consumer }
          flash[:notice] = 'Your bid and shipping address have been confirmed!'
        else
          format.html { render :edit }
          format.json { render json: @deal.errors, status: :unprocessable_entity }
        end
      end
  end

  def index
    @orders = @consumer.orders.all
    # SPECIFY THE DEAL AS SUCH SO THAT WE CAN REFER TO EACH DEAL BY NAME @deal = Deal.find(order.deal_id)
  end

  def edit
    @order = Order.find(params[:id])
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
    @deal = Deal.find(@order.deal_id)
  end
  def set_order
    @order = Order.find(params[:id])
  end
  def set_consumer
    @consumer = current_consumer
  end
  def order_params
    params.require(:order).permit(:consumer_id, :deal_id, :quantity, :address)
  end
  def check_threshold
    if @deal.orders.count >= @deal.threshold
      threshold_met = true
    else
      threshold_met = false
    end
  end
  def check_if_still_active
    if @deal.orders.count >= @deal.threshold
      flash[:notice] = 'You can no longer update the shipping address for this item. It has already been shipped to the winner.'
      redirect_to :back
    else
    end
  end

end
