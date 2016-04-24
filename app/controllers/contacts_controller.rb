class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.request = request

    if verify_recaptcha(model: @contact)
      #If captcha entered correctly
      if ModMailer.contact_form(contact_params).deliver
        #Mailer sent successfully
        flash.now[:notice] = "Thank you for your message"
      else
        #Mailer failed to deliver
        flash.now[:error] = "Cannot send message"
        render :new
      end
    else
      #If missed verification
      render :new
      flash.now[:notice] = "Please verify yourself by clicking 'I'm not a robot'"
    end

  end

  private
    def contact_params
      params.require(:contact).permit(:name, :email, :message)
    end
end
