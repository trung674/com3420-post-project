class ContactsController < ApplicationController
  before_action :authenticate_mod!, only: [:edit]

  def new
    @contact = Contact.new
    #Select info (contact address, phone, working hour) from database
    @editable_contents = EditableContent.find(2,3,4)
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.request = request

    if verify_recaptcha(model: @contact) && @contact.save
      #If captcha entered correctly
      if ModMailer.contact_form(contact_params).deliver
        #Mailer sent successfully
        redirect_to root_path, notice: 'Message sent successfully'
      else
        #Mailer failed to deliver
        flash.now[:error] = "Cannot send message"
        render :new
      end
    else
      #If missed verification
      redirect_to '/contacts' #using render breaks mercury editor..?
      flash.now[:notice] = "Please verify yourself by clicking 'I'm not a robot'"
    end

  end

  def edit
    @editable_contents = EditableContent.find(2,3,4)
  end

  def update
    # bad noob codes but at least it works :(
    @editable_contents = EditableContent.find(2,3,4)
    @editable_contents[0].content = params[:editable_content][:contact_address]
    @editable_contents[1].content = params[:editable_content][:contact_phone]
    @editable_contents[2].content = params[:editable_content][:working_hour]
    if @editable_contents[0].save! && @editable_contents[1].save! && @editable_contents[2].save!
      redirect_to modpanel_path, notice: 'Contact info was successfully updated.'
    else
      redirect_to contacts_edit_path notice: 'Something was wrong. Please try again !'
    end
  end

  private
    def contact_params
      params.require(:contact).permit(:name, :email, :message)
    end
end
