class AddColumnLastUpdateToUsers < ActiveRecord::Migration
  def change
  	  	add_column :users, :lastUpdated, :date
  end
end
