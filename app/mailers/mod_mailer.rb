class ModMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.mod_mailer.contact_form.subject
  #
  def contact_form(contact)
    @greeting = "Hi"

    mail to: "asacook1@sheffield.ac.uk"
  end
end
