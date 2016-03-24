class SearchController < ApplicationController


  def search
    @search = [params[:search]]
    @records = Record.where :approved => true
  end
end