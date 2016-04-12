class SearchController < ApplicationController


  # TODO: This generates an error when no box is ticked
  # TODO: This also seems to break if there is more than one record for a medium
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


      records = Record.where('approved == ? AND (location LIKE ? OR description LIKE ? OR title LIKE ?) AND medium_id IN (?)', true,
                             "%#{@search[0]}%", "%#{@search[0]}%", "%#{@search[0]}%", ids)
      medium_ids = []
      records.each do |getId|
        medium_ids.append(getId.medium_id)
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