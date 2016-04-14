class PagesController < ApplicationController
  before_action :authenticate_mod!, only: [:mercury_update]

  def home
    @current_nav_identifier = :home
    @events = Event.all
    @wallpapers = Wallpaper.all
  end

  def contact
    @current_nav_identifier = :contact
  end

  def about
    # TODO make this only editable when logged in!!
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
