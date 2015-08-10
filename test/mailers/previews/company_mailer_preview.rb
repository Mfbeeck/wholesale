# Preview all emails at http://localhost:3000/rails/mailers/company_mailer
class CompanyMailerPreview < ActionMailer::Preview
  def welcome_email_preview
    CompanyMailer.welcome_email(Consumer.first)
  end

  def winner_email_preview
    CompanyMailer.winner_email(Consumer.find(2), Deal.find(14))
  end

  def looser_email_preview
    CompanyMailer.looser_email(Consumer.find(1), Deal.find(12))
  end
end
