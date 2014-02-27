class ChangeDeviceUpdatedFromDateToDatetime < ActiveRecord::Migration
  def up
  	change_column :devices, :lastUpdated, :datetime
  end

  def down
  	change_column :devices, :lastUpdated, :date
  end
end
