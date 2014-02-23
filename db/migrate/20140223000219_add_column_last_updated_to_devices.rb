class AddColumnLastUpdatedToDevices < ActiveRecord::Migration
  def change
  	  	 add_column :devices, :lastUpdated, :date
  end
end
