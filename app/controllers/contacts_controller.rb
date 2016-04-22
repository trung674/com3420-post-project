class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.request = request

    if verify_recaptcha(model: @contact)
      if ModMailer.contact_form(contact_params).deliver
        flash.now[:notice] = "Thank you for your message"
      else
        flash.now[:error] = "Cannot send message"
        render :new
      end
    end

  end

  private
    def contact_params
      params.require(:contact).permit(:name, :email, :message)
    end
end
