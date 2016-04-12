# Preview all emails at http://localhost:3000/rails/mailers/mod_mailer
class ModMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/mod_mailer/contact_form
  def contact_form
    ModMailer.contact_form
  end

end
