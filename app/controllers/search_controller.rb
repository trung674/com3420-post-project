class SearchController < ApplicationController


  def search
    # TODO search logic will go here
    @search = [params[:search]]
    @type = [params[:type]]
    # More efficient to search by type first
    medium_results = (Medium.where :type => @type)
    ids = medium_results.ids
    records = Record.where('(location LIKE ? OR description LIKE ? OR title LIKE ?) AND medium_id IN (?)',
                            "%#{@search[0]}%", "%#{@search[0]}%", "%#{@search[0]}%", ids)
  #   TODO decide what is in the return hash - see below

  #   linked filename - Title
  #   date
  #   location (add link)
  #   Type

  #   TODO have a return hash
  end
end