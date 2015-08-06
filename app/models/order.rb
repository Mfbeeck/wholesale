class Order < ActiveRecord::Base
  belongs_to :deal
  belongs_to :consumer

  # after_save :check_if_threshold_reached

  validates :consumer_id, uniqueness: { scope: :deal_id,
    message: "can only have one bid per deal." }

  def send_message(message)
    @profile = current_user.profile
    twilio_number = ENV["TWILIO_NUMBER"]
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    message = @client.account.messages.create(
      :from => twilio_number,
      :to => @profile.country_code+@profile.phone,
      :body => message
    )
    puts message.to
  end

  def send_message
    @client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token 

  require 'rubygems'
  require 'twilio-ruby'

  account_sid = "ACxxxxxxxxxxxxxxxxxxxxxxxx"
  auth_token = "yyyyyyyyyyyyyyyyyyyyyyyyy"
  client = Twilio::REST::Client.new account_sid, auth_token

  from = "+14159998888" # Your Twilio number

  friends = {
  "+14153334444" => "Curious George",
  "+14155557775" => "Boots",
  "+14155551234" => "Virgil"
  }
  friends.each do |key, value|
    client.account.messages.create(
      :from => from,
      :to => key,
      :body => "Hey #{value}, Monkey party at 6PM. Bring Bananas!"
    )
    puts "Sent message to #{value}"
  end

  end





  private


end
