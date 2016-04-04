class ModsController < ApplicationController
  
  before_action :authenticate_mod!, only: [:modpanel, :modlist, :update, :modedit]
  
  #Instantiate authorisation with CanCanCan
  load_and_authorize_resource
  
  def modpanel
  end

  def modlist
    @mods = Mod.all
  end
  
  def modedit
    @alteredMod = Mod.new
  end
  
  def update    
    @alteredMod = Mod.find_by(email: mod_params[:email])
    @alteredMod.isActive = true
    if @alteredMod.save
      redirect_to "/modpanel"
      flash[:notice] = "Update successful"
    else
      redirect_to "/modedit"
      flash[:notice] = "There was an error, update unsuccessful"
    end
  end

  private
    def mod_params
      params.require(:mod).permit(:email)
    end  
end
