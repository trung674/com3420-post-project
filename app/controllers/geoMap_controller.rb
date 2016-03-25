class GeomapController < ApplicationController

  def map
    @current_nav_identifier = :map
    @lat_lng = []
    Record.all.each do |thing|
      #need to check that its not nil, they might not have clicked on the map.
      #this could be in controller but then it would be loaded on every static page.
      if thing.latitude
        @lat_lng.append({lat: thing.latitude , lng: thing.longitude})
      end
    end
  end
end