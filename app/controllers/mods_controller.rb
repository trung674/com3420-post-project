class ModsController < ApplicationController
  
  #Instantiate authorisation with CanCanCan
  load_and_authorize_resource
  
  def modpanel
  end

  def modlist
    @mods = Mod.all
  end
  
end
