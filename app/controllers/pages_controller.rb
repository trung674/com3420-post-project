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

  def report
    @current_nav_identifier = :reports
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
    Record.where(:approved => true).each do |thing|
      #this check for the 'people' who didnt manage to click on the map when uploading
      if thing.latitude
        @lat_lng.append({lat: thing.latitude, lng: thing.longitude, infoWindow: {
            content: "<table>
             <tbody>
            <tr>
            <th>Title: </th>
                <td>
                  <a href='media/#{thing.medium_id}'>
                    #{thing.title}
                  </a>
                </td>
          </tr>
          <tr>
            <th>Date: </th>
              <td>
                #{thing.ref_date}
              </td>
          </tr>
          <tr>
            <th>Location: </th>
              <td>
                #{thing.location}
              </td>
          </tr>
          </tbody>
        </table>"
        }})


        @obj_array.append(thing)
      end
    end
  end

  def search

    if !params[:items].nil? || ![params[:search]].nil?
      if params[:items].nil?
        # If the user provides no choice, the default is to return everything
        @type = %w{Document Recording Image Text}
      else
        @type = params[:items]
        @search = []
      end
    else
      @type = %w{Document Recording Image Text}
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

    records =[]
    ids.each do |id|
      record = (Record.where('(location LIKE ? OR description LIKE ? OR title LIKE ?)',
                              "%#{@search[0]}%", "%#{@search[0]}%", "%#{@search[0]}%"))
                    .where(:approved=>true, :medium_id=>id).order(:created_at)
      if record[-1]
        records.append(record[-1])
      end
    end




    if records
      medium_ids = []
      records.each do |getId|
        medium_ids.append(getId.medium_id)
      end
    end

    if @type.include? 'Recording'
      # if recording is in the search params
      # then look in the directorys
      # get each medium id that is a recording
      # go into each of these directories and search the tml
      # add the medium id to an array if the tml contains the search string
      trans_param = []
      ids = Medium.where(:type => 'Recording').ids
      ids.each do |test|
        if !medium_ids.include? test
          trans_param.append(test)
        end
      end
      extra_records = transcript_search(trans_param)
      extra_records.each do |rec|
        records.append(rec)
        medium_ids.append(rec.medium_id)
      end
    end



    # This is the array of hashes that we send to the view based on the search.
    @results_hashes = []

    # for loops create the array of the useful infomation. More efficient than passing objects.
    for x in 0..(records.length-1)
      @results_hashes.append({:title => records[x].title, :id => records[x].medium_id,
                              :date => records[x].ref_date, :location => records[x].location,
                              :type => (Medium.where(:id=> records[x].medium_id))[0].type})
    end
  end

  private
  def transcript_search(ids)
    if ids
      recording_ids = ids
      trans_search_hits = []
      recording_ids.each do |id|
        (Dir.entries('public/uploads/recording/'+''+id.to_s)).each do |name|
          if name=~/.*\.xml$/
            #   TODO put search code here
            result = false
            file = Nokogiri::XML(File.open(name))
            tag_set = file.xpath("//label")
            tag_set.each do |node|
              puts node.to_s
              result = node.to_s.include?(@search[0])
              if result
                trans_search_hits.append(id)
              end
            end
          end
        end
      end

      # todo use the medium ids to get the most recent record
      records = []

      return records

    end
  end

end
