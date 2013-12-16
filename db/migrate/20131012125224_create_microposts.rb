class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.integer :user_id
      t.string :content

      t.timestamps
    end
    #we create a multiple key index, Active Record uses both keys
    add_index :microposts, [:user_id, :created_at]
  end
end
