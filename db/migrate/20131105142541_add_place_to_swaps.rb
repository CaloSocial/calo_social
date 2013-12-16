class AddPlaceToSwaps < ActiveRecord::Migration
  def change
    add_column :swaps, :place, :string
  end
end
