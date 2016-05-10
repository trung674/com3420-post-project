class Ability
  include CanCan::Ability

  def initialize(current_mod)
    current_mod ||= Mod.new
    
    #if a mod is marked as ACTIVE, list the controller methods they can use as below
    if current_mod.isActive?
      can :modpanel, :all
      can :read, Impression
    end

    if current_mod.isAdmin
      can :modlist, :all
      can :modedit, :all
      can :update, :all
    end

  end

end
