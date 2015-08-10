class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  helper_method :current_supplier
  helper_method :current_consumer
#  helper_method :send_message

  def current_supplier
    @current_supplier ||= Supplier.find(session[:supplier_id]) if session[:supplier_id]
  end

  def current_consumer
    if current_supplier.nil?
      @current_consumer ||= Consumer.find(session[:consumer_id]) if session[:consumer_id]
    end
  end

  def force_consumer_login
    redirect_to new_consumer_session
  end

  #Method to send messages using Twilio. It takes the message you want to send and the consumer you want to send it to as arguments.
  #This method will be called in the orders_controllers update.
  def send_message(consumer, message)
    @client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    twilio_number = ENV["TWILIO_NUMBER"]
    message = @client.messages.create(
      from: twilio_number,
      to: '+1' + consumer.phone_number,
      body: message
      )
    puts "****************************************************************************"
    puts message.status
    puts "****************************************************************************"
  end

  def force_supplier_login
    redirect_to new_supplier_session
  end

  def check_if_logged_in
    if current_consumer || current_supplier
    else
    end
  end

  def require_logged_in
    return true if (current_supplier || current_consumer)

    redirect_to root_path
    return false
  end

  def set_array_of_current_consumer_orders_deal_ids
    if current_consumer
      @current_consumer_orders_deal_ids = current_consumer.orders(:select => :deal_id).collect(&:deal_id)
    else
    end
  end


end
