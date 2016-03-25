class AddActiveColumnToMod < ActiveRecord::Migration
  def change
    add_column :mods, :isActive, :boolean
  end
end
