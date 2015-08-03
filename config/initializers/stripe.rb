Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]


#PUBLISHABLE_KEY=pk_test_0ed9TtLgYjWa691GlNht1NQE SECRET_KEY=sk_test_NgAr9M0y3NZbPg29R3w0Hmnu rails s
