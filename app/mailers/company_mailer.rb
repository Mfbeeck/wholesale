class CompanyMailer < ApplicationMailer
  default from: 'parlayvous.games@gmail.com'

  def welcome_email(consumer)
    @user = consumer
    @url  = 'https://parlayvous.herokuapp.com/new_consumer_session'
    email_with_name = %("#{@user.first_name}" <#{@user.email}>)
    mail(to: email_with_name, subject: 'Welcome to ParlayVous!!')
  end

  def winner_email(consumer, deal)
    @deal = deal
    @user = consumer
    @url  = 'https://parlayvous.herokuapp.com/new_consumer_session'
    email_with_name = %("#{@user.first_name}" <#{@user.email}>)
    mail(to: email_with_name, subject: 'ParlayVous! You just won!')
  end
end
