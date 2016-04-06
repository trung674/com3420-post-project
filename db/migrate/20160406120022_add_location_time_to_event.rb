class AddLocationTimeToEvent < ActiveRecord::Migration
  def change
    add_column :events, :location, :string
    add_column :events, :time, :string
  end
end
