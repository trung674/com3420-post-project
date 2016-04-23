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
    render text: ''
  end

  def map
    # this is done on the load of every map page /get or /post
    @current_nav_identifier = :map
    @lat_lng = []
    @obj_array = []
    # This code ensures that only the most recent approved record gets shown
    med_ids = Medium.all.ids
    records = []
    med_ids.each do |id|
      record = Record.where(:medium_id => id, :approved => true).order(:created_at)
      if record[-1]
        records.append(record[-1])
      end
    end
    # for each record add the html for infoWindow and lat&lng. this all for the markers
    records.each do |thing|
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
      # If the user provides no choice, the default is to return everything
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

    # only search transcripts if the user has said to look at recordings
    if @type.include? 'Recording'
      trans_param = []
      # Get the ids of all the mediums that are recordings
      ids = Medium.where(:type => 'Recording').ids
      # make sure that they haven't already been returned, to save time.
      ids.each do |test|
        if !medium_ids.include? test
          trans_param.append(test)
        end
      end
      # search the transcripts of the recordings that haven't already been returned
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
                              :type => (Medium.where(:id => records[x].medium_id))[0].type})
    end
  end

  private
  def transcript_search(ids)
    # Function that takes recording's medium ids and searches the transcripts for matches
    if ids
      trans_search_hits = []
      ids.each do |med_id|
        # looks through each directory to find a file with an xml ending.
        (Dir.entries("#{Rails.root}/uploads/recording/"+''+med_id.to_s)).each do |name|
          if name=~/.*\.xml$/
            # read in the xml - label tags only! <label></label>
            labels = Nokogiri::XML(File.open("#{Rails.root}/uploads/recording/"+''+med_id.to_s+'/'+name)).xpath('//label')
            file_string = ''
            labels.each do |node|
              text = node.text
              if text != '!SENT_START'
                file_string = file_string +' '+ text.downcase
              end
            end
            # if the string contains the search string then it will add the record to the 'hits' array.
            if file_string.include?(@search[0].downcase)
              trans_search_hits.append(med_id)
            end
          end
        end
      end

      records = []
      trans_search_hits.each do |id|
        record_matches = Record.where(:medium_id => id).order(:created_at)
        if record_matches[-1]
          records.append(record_matches[-1])
        end
      end
      # returns the records
      return records

    end
  else
    return []
  end

end
