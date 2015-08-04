class ChargesController < ApplicationController
  def new
  #  redirect_to new_order_path
  end

  def create_charge
    # Amount in cents


    p "***********************"
    p "This is Carges COntroller #{Deal.find(current_consumer.orders.last[:deal_id]).price}"
    p "***********************"



    # # Set your secret key: remember to change this to your live secret key in production
    # # See your keys here https://dashboard.stripe.com/account/apikeys
    # Stripe.api_key = "sk_test_BQokikJOvBiI2HlWgH4olfQ2"
    #
    # # Get the credit card details submitted by the form
    # token = params[:stripeToken]
    #
    # # Create a Customer
    # customer = Stripe::Customer.create(
    #   :source => token,
    #   :description => "Example customer"
    # )
    #
    # # Charge the Customer instead of the card
    # Stripe::Charge.create(
    #     :amount => 1000, # in cents
    #     :currency => "usd",
    #     :customer => customer.id
    # )
    # # Save the customer ID in your database so you can use it later
    # save_stripe_customer_id(user, customer.id)
    #
    # # Later...
    # customer_id = get_stripe_customer_id(user)
    #
    # Stripe::Charge.create(
    #   :amount   => 1500, # $15.00 this time
    #   :currency => "usd",
    #   :customer => customer_id
    # )

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



    #redirect_to consumer_orders_path(current_consumer)

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path
  end
end
