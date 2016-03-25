class AboutController < ApplicationController

  def about
    # TODO make this only editable when logged in!!
    @current_nav_identifier = :about
    @about_content = EditableContent.find_by name: 'about'
  end



end


