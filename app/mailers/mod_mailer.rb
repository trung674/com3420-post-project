class ModMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.mod_mailer.contact_form.subject
  #
  def contact_form
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
