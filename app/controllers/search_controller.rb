class SearchController < ApplicationController


  def search
    @records = Record.where :approved => true
  end
end