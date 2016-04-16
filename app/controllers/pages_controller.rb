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

  def search

    if params[:items] || [params[:search]]
      if params[:items].nil?
        # If the user provides no choice, the default is to return everything
        @type = %w{Document Recording Image Text}
      else
        @type = params[:items]
      end

      @search = [params[:search]]
      # More efficient to search by type first
      ids = []
      if @type
        for y in 0..@type.length-1
          medium_results = (Medium.where :type => @type[y]).ids
          medium_results.each do |add|
            ids.push(add)
          end
        end
      end

      if ids
        records = (Record.where('(location LIKE ? OR description LIKE ? OR title LIKE ?)',
                                "%#{@search[0]}%", "%#{@search[0]}%", "%#{@search[0]}%"))
                      .where(:approved=>true, :medium_id=>ids)
      else
        records = []
      end

      if records
        medium_ids = []
        records.each do |getId|
          medium_ids.append(getId.medium_id)
        end
      end



      # This is the array of hashes that we send to the view based on the search.
      @results_hashes = []

      # for loops create the array of the useful infomation. More efficient than passing objects.
      for x in 0..(records.length-1)
        @results_hashes.append({:title => records[x].title, :id => records[x].medium_id,
                                :date => records[x].ref_date, :location => records[x].location,
                                :type => (Medium.where('id == (?)', records[x].medium_id))[0].type})
      end
    end
  end

end
