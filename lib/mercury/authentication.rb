module Mercury
  module Authentication

    def can_edit?
      if mod_signed_in?
        true  # check here to see if the user is logged in/has access
      end  
    end

  end
end
