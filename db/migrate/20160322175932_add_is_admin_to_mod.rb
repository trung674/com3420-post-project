class AddIsAdminToMod < ActiveRecord::Migration
  def change
    add_column :mods, :isAdmin, :boolean
  end
end
