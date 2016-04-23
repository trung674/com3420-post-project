# == Schema Information
#
# Table name: mods
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  isActive               :boolean
#  isAdmin                :boolean
#
# Indexes
#
#  index_mods_on_email                 (email) UNIQUE
#  index_mods_on_reset_password_token  (reset_password_token) UNIQUE
#

class ModsController < ApplicationController
  
  before_action :authenticate_mod!, only: [:modpanel, :modlist, :update, :modedit]
  
  #Instantiate authorisation with CanCanCan
  load_and_authorize_resource
  
  def modpanel
    @approveRec = Record.where(approved: false)
  end

  def modlist
    @mods = Mod.all
  end
  
  def modedit
    @alteredMod = Mod.new
  end
  
  def update    
    @alteredMod = Mod.find_by(email: mod_params[:email])    
    @updateMsg = String.new

    if (@alteredMod.isActive != true) && (@alteredMod.isAdmin != true) #If mod inactive and not an admin
      #Set mod to active
      @alteredMod.isActive = true
      @updateMsg = "Moderator successfully activated"
    elsif (@alteredMod.isActive == true) && (@alteredMod.isAdmin != true) #If the mod is active and not an admin
      @alteredMod.isActive = false
      @updateMsg = "Moderator successfully deactivated"
    else
      @updateMsg = "Site administrators cannot be deactivated." #Cancel update, display error.
    end

    #If successful, redirect to panel and display message.
    if @alteredMod.save
      redirect_to "/modpanel"
      flash[:notice] = @updateMsg
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
