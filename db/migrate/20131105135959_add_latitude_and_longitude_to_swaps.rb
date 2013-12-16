class AddLatitudeAndLongitudeToSwaps < ActiveRecord::Migration
  def change
    add_column :swaps, :latitude, :float
    add_column :swaps, :longitude, :float
  end
end
