# Preview all emails at http://localhost:3000/rails/mailers/company_mailer
class CompanyMailerPreview < ActionMailer::Preview
  def welcome_email_preview
    CompanyMailer.welcome_email(Consumer.first)
  end
end
