require 'twilio-ruby'

class OrdersController < ApplicationController
  before_action :set_consumer, only: [:index, :create, :create_points_order, :edit, :update, :destroy]
  before_action :set_order, only: [:edit, :update, :show]
  before_action :set_deal, only: [:edit, :update, :show]
  before_action :check_if_winner_assigned, only: [:edit]
  skip_before_filter :verify_authenticity_token, only: [:send_message] #protect_from_forgery method disabled to allow Twilio to send text messages

  def new
  end

  def create_points_order
    @deal = Deal.find(params[:deal_id])
    @order = Order.new
    @order.consumer_id = current_consumer.id
    @order.deal_id = params[:deal_id]
    @order.address = current_consumer.address
    if @order.save
      @consumer.total_points = (@consumer.total_points - @deal.price.to_i)
      @consumer.save #this just returns false, how do i get it to actually save
      if @deal.has_exceeded_threshold?
        @deal.threshold_reached = true
        @deal.save
      end
      redirectsss_to edit_consumer_order_path(current_consumer, @order)
    else
      flash[:notice] = 'You have already bid on this deal!'
      redirect_to :back
    end
  end

  def create
    @deal = Deal.find(params[:deal_id])
    @order = Order.new
    @order.consumer_id = current_consumer.id
    @order.deal_id = params[:deal_id]
    @order.address = current_consumer.address
    if @order.save
      create_charge
      @consumer.total_points = (@consumer.total_points + 1)
      @consumer.save
      if @deal.has_exceeded_threshold?
        @deal.threshold_reached = true
        @deal.save
      end
    else
      flash[:notice] = 'You have already bid on this deal!'
      redirect_to :back
    end
  end


  #Method to create Stripe charge immediatly after an order has been created using the "create" method.
  def create_charge
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

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path
  end

  #Method to send messages using Twilio. It takes the message you want to send and the consumer you want to send it to as arguments.
  def send_message(consumer, message)
    @client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    message = @client.messages.create(
      from: '+19283795466',
      to: consumer.phone_number,
      body: message
      )
    render plain: message.status
  end

  def update
    @deal = Deal.find(@order.deal_id)
    if !@deal.winning_consumer
      respond_to do |format|
        if @order.update(order_params)
          if @deal.orders.count >= @deal.threshold
            @array_of_orders = @deal.orders(:select => :id).collect(&:id)
            @winning_order_id = @array_of_orders.sample #IF WE WANT TO HAVE MULTIPLE WINNERS WE CAN MAKE A FIELD IN THE DEALS FORM FOR NUMBER OF WINNERS AND THEN CALL .sample(@deal.number_of_winners) to select a random sample of that many people
            @deal.winning_order_id = @winning_order_id
            @winning_order = Order.find(@deal.winning_order_id)
            @winning_consumer = Consumer.find(@winning_order.consumer_id)
            @winning_username = @winning_consumer.username
            @deal.winners_shipping_address = @winning_order.address
            @deal.winning_consumer = @winning_username
            @deal.save
            send_message(@winning_consumer, "Parlayvous! You have just won this item: #{@deal.name}.")

            format.html { redirect_to order_path(@order)}
            format.json { render :show, status: :ok, location: current_consumer }
            flash[:notice] = 'Your bid and shipping address have been confirmed and a winner has been announced!'
          else
            format.html { redirect_to order_path(@order)}
            format.json { render :show, status: :ok, location: current_consumer }
            flash[:notice] = 'Your bid and shipping address have been confirmed!'
          end
        else
          format.html { render :edit }
          format.json { render json: @deal.errors, status: :unprocessable_entity }
        end
      end
    end
  end


  def index
    @orders = @consumer.orders.all
  end

  def edit
  end

  def show
    if session[:consumer_id] == @order.consumer_id
    else
      redirect_to orders_path
    end
  end

  def destroy
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def set_deal
    @deal = Deal.find(@order.deal_id)
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

  def check_if_consumer_has_enough_points
    if current_consumer.total_points >= @deal.price.to_i
    else
    raise
    end
  end

  def check_if_winner_assigned
    if @deal.winning_consumer
      flash[:notice] = "You can no longer update the shipping address for this item. It has already been shipped to the winner. \n If you are the winner and want to change your address please contact customer service at CarlosHasCheapDeals@gmail.com"
      redirect_to order_path(@order)
    else
    end
  end

end
