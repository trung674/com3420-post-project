class ModsController < ApplicationController
  
  #authorize_resource

  def modpanel
  end

  def modlist
    @mods = Mod.all
  end

end
