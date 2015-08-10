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

  def looser_email(consumer, deal)
    @deal = deal
    @user = consumer
    @url  = 'https://parlayvous.herokuapp.com/new_consumer_session'
    email_with_name = %("#{@user.first_name}" <#{@user.email}>)
    mail(to: email_with_name, subject: 'One of your games is over')
  end

  def info_email(consumer, deal)
    @deal = deal
    @user = consumer
    @url  = 'https://parlayvous.herokuapp.com/new_consumer_session'
    email_with_name = %("#{@user.first_name}" <#{@user.email}>)
    mail(to: email_with_name, subject: 'You are now participating for a <%= #{@deal.name} %>!')
  end
end
