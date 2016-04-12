class GeomapController < ApplicationController

  def map
    if !params[:lat].nil? && !params[:lng].nil?
      # this is the code that gets done when there are both parameters provided
      lat = params[:lat]
      lng = params[:lng]
      @result = Record.where(:latitude => lat, :longitude => lng)[0]

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