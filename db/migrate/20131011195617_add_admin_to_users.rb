class AddAdminToUsers < ActiveRecord::Migration
  def change
  	# Users are not administrators by default
    add_column :users, :admin, :boolean, default: false
  end
end
