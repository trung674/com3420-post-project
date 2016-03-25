class PagesController < ApplicationController
  def home
    @current_nav_identifier = :home
  end

  def map
    @current_nav_identifier = :map
  end

  def about
    @current_nav_identifier = :about
    @about_content = EditableContent.find_by name: 'about'
  end

  def mercury_update
    content = EditableContent.find_by name: 'about'
    content.content = params[:content][:about_content][:value]
    content.save!
    render text: ""
  end
end
