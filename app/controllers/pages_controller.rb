class PagesController < ApplicationController

  def home
    @current_nav_identifier = :home
  end

  def about
    # TODO make this only editable when logged in!!
    @current_nav_identifier = :about
    @about_content = EditableContent.find_by name: 'about'
  end

  def contact
    @current_nav_identifier = :contact
  end

  def mercury_update
    content = EditableContent.find_by name: 'about'
    content.content = params[:content][:about_content][:value]
    content.save!
    render text: ""
  end
end
