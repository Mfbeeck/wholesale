class CompanyMailer < ApplicationMailer
  default from: 'parlayvous.games@gmail.com'

  def welcome_email(consumer)
    @user = consumer
    @url  = 'https://powerful-reef-4780.herokuapp.com/new_consumer_session'
    email_with_name = %("#{@user.first_name}" <#{@user.email}>)
    mail(to: email_with_name, subject: 'Welcome to ParlayVous!!')
  end
end
