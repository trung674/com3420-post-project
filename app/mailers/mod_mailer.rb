class ModMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.mod_mailer.contact_form.subject
  #
  def contact_form(contact_params)
    @greeting = "This message is to inform you that someone has written to you via Village Memories"
       
    @name = contact_params[:name]
    @email = contact_params[:email]
    @message = contact_params[:message]

    mail to: "asacook1@sheffield.ac.uk"

  end
end
