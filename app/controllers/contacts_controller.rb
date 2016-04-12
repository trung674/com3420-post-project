class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.request = request

    @name = contact_params[:name]
    @email = contact_params[:email]
    @message = contact_params[:message]

    if ModMailer.contact_form(@contact).deliver
      flash.now[:notice] = "Thank you for your message"
    else
      flash.now[:error] = "Cannot send message"
      render :new
    end
  end

  private
    def contact_params
      params.require(:contact).permit(:name, :email, :message, :nickname)
    end
end
