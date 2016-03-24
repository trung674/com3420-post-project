class SearchController < ApplicationController


  def search
    # TODO search logic will go here
    @search = [params[:search]]
    @records = Record.where('location LIKE ? OR description LIKE ? OR title LIKE ?', "%#{@search[0]}%", "%#{@search[0]}%", "%#{@search[0]}%")
  end
end