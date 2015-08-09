 require 'twilio-ruby'

class OrdersController < ApplicationController
  before_action :set_consumer, only: [:index, :create, :create_points_order, :edit, :update, :destroy]
  before_action :set_order, only: [:edit, :update, :show]
  before_action :set_deal, only: [:edit, :update, :show]
  before_action :check_if_winner_assigned, only: [:edit]
  skip_before_filter :verify_authenticity_token, only: [:send_message] #protect_from_forgery method disabled to allow Twilio to send text messages

  def new
  end

  #This method creates an order after a logged in consumer clicks on the "Pay With Points" button.
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
      redirect_to edit_consumer_order_path(current_consumer, @order)
    else
      flash[:notice] = 'You have already bid on this deal!'
      redirect_to :back
    end
  end

  #This method creates an order after a logged in consumer enters his/her credit card and clicks on the Stripe "Pay" button.
  def create
    @deal = Deal.find(params[:deal_id])
    @order = Order.new
    @order.consumer_id = current_consumer.id
    @order.deal_id = params[:deal_id]
    @order.address = current_consumer.address
    if @order.save
      create_charge #This method must be called ONLY if an order has already been created, otherwise it will break.
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
      :description => 'Prlayvous Ticket',
      :currency    => 'usd'
    )

    #After paying with Stripe, consumers are prompt to confirm their shipping address.
    redirect_to edit_consumer_order_path(current_consumer, @order)

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path
  end

  def update
    @deal = Deal.find(@order.deal_id)
    if !@deal.winning_consumer
      #respond_to do |format|
      if @order.update(order_params)
        #A text message is sent to consumers to confirm they are now participating in a lottery.
        #The send_message method is defined in the application_controller send_message(consumer, message).
        new_participant = Consumer.find(@order.consumer_id)
        send_message(new_participant, "#{new_participant.first_name}, welcome to a new ParlayVous game!!! Good luck on winning the #{@deal.name}.")
        if @deal.orders.count >= @deal.threshold
          @array_of_orders = @deal.orders(:select => :id).collect(&:id)
          @winning_order_id = @array_of_orders.sample #IF WE WANT TO HAVE MULTIPLE WINNERS WE CAN MAKE A FIELD IN THE DEALS FORM FOR NUMBER OF WINNERS AND THEN CALL .sample(@deal.number_of_winners) to select a random sample of that many people
          @deal.winning_order_id = @winning_order_id
          @winning_order = Order.find(@deal.winning_order_id)
          @winner = Consumer.find(@winning_order.consumer_id)
          @winning_username = @winner.username
          @deal.winners_shipping_address = @winning_order.address
          @deal.winning_consumer = @winning_username
          @deal.save

          #This part of the code sends different text messages to the winner and the others.
          @array_of_orders.each do |order_num|
            consumer_identification = Order.find(order_num).consumer_id
            consumer = Consumer.find(consumer_identification)
            if consumer.phone_number.length == 10 #add a !consumer.phone_number.nil? && when we have the text update issues
              if consumer_identification == @winner.id
                message = "ParlayVous!!! #{@winner.first_name.capitalize}, you just won this item: #{@deal.name}. It will be shipped to #{@deal.winners_shipping_address}. If this is not correct, please contact customer service."
                CompanyMailer.winner_email(@consumer, @deal).deliver
              else
                message = "Sorry, #{consumer.first_name.capitalize}. Participant #{@winner.username} won this item: #{@deal.name}."
              end
            send_message(consumer, message)
            end
          end
          redirect_to order_path(@order)
          #format.html { redirect_to order_path(@order)}
          #format.json { render :show, status: :ok, location: current_consumer }
          flash[:notice] = 'Your bid and shipping address have been confirmed and a winner has been announced!'
        else
          redirect_to order_path(@order)
          #format.html { redirect_to order_path(@order)}
          #format.json { render :show, status: :ok, location: current_consumer }
          flash[:notice] = 'Your bid and shipping address have been confirmed!'
        end
      else
        render :edit
        # format.html { render :edit }
        # format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
      #end
    #else This would only be if someone places an order on a deal that already has a winner which should never happen
    end
  end

  def index
    @orders = @consumer.orders.all
  end

  def edit
  end

  def show
    unless session[:consumer_id] == @order.consumer_id
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
    unless current_consumer.total_points >= @deal.price.to_i
      raise
    end
  end

  def check_if_winner_assigned
    if @deal.winning_consumer
      flash[:notice] = "You can no longer update the shipping address for this item. It has already been shipped to the winner. \n If you are the winner and want to change your address please contact customer service at CarlosHasCheapDeals@gmail.com"
      redirect_to order_path(@order)
    end
  end

end
