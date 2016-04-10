class SearchController < ApplicationController


  # TODO: This generates an error when no box is ticked
  # TODO: This also seems to break if there is more than one record for a medium
  def search
    @search = [params[:search]]
    @type = params[:items]
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


    records = Record.where('approved == ? AND (location LIKE ? OR description LIKE ? OR title LIKE ?) AND medium_id IN (?)', true,
                            "%#{@search[0]}%", "%#{@search[0]}%", "%#{@search[0]}%", ids)
    medium_ids = []
    records.each do |getId|
      medium_ids.append(getId.medium_id)
    end

    medium_final = Medium.where('id IN (?)', medium_ids)

    # This is the array of hashes that we send to the view based on the search.
    @results_hashes = []

    # for loops create the array of the useful infomation. More efficient than passing objects.
    for x in 0..(records.length-1)
      @results_hashes.append({:title => records[x].title, :id => medium_final[x].id,
                              :date => records[x].ref_date, :location => records[x].location,
                              :type => medium_final[x].type})
    end

  end
end