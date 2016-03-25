class AddLatitudeAndLongitudeToRecords < ActiveRecord::Migration
  def change
    add_column :records, :latitude, :float
    add_column :records, :longitude, :float
  end
end
