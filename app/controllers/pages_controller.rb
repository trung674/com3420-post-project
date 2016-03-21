class PagesController < ApplicationController
  
  def home
    @current_nav_identifier = :home
  end

  def map
    @current_nav_identifier = :map
  end
  
  def about
    @current_nav_identifier = :about
  end  
  
  def modpanel
  end
  
end
