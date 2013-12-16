class CreateSwaps < ActiveRecord::Migration
  def change
    create_table :swaps do |t|
      t.integer :user_id
      t.string :description
      t.string :offer
      t.string :want

      t.timestamps
    end
    add_index :swaps, [:user_id, :created_at]
  end
end
