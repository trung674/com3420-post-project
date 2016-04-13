class PagesController < ApplicationController
  before_action :authenticate_mod!, only: [:mercury_update]

  def home
    @current_nav_identifier = :home
    @events = Event.all
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

  def map
    if !params[:lat].nil? && !params[:lng].nil?
      # this is the code that gets done when there are both parameters provided
      lat = params[:lat]
      lng = params[:lng]
      @result = Record.where(:latitude => lat, :longitude => lng, :approved => true)[0]

    end
    # this is done on the load of every map page /get or /post
    @current_nav_identifier = :map
    @lat_lng = []
    @obj_array = []
    Record.all.each do |thing|
      #this check for the 'people' who didnt manage to click on the map when uploading
      if thing.latitude
        @lat_lng.append({lat: thing.latitude , lng: thing.longitude})
        @obj_array.append(thing)
      end
    end
  end

end
