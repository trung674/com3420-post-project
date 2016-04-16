class CreateWallpapers < ActiveRecord::Migration
  def change
    create_table :wallpapers do |t|
      t.string :image
      t.string :description

      t.timestamps null: false
    end
  end
end
