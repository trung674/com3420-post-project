class SearchController < ApplicationController


  def search
    # TODO search logic will go here
    @search = [params[:search]]
    @type = params[:items]
    # More efficient to search by type first

    ids = []
    for y in 0..@type.length-1
      medium_results = (Medium.where :type => @type[y]).ids
      medium_results.each do |add|
        ids.push(add)
      end
    end


    records = Record.where('(location LIKE ? OR description LIKE ? OR title LIKE ?) AND medium_id IN (?)',
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
      @results_hashes.append({:title => records[x].title, :url => medium_final[x].upload,
                              :date => records[x].ref_date, :location => records[x].location, :type => medium_final[x].type})
    end

  end
end