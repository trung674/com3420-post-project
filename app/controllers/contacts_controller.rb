class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if ModMailer.contact_form(@contact).deliver
      flash.now[:notice] = "Thank you for your message"
    else
      flash.now[:error] = "Cannot send message"
      render :new
    end

  end

end
