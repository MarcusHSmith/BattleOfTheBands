class AddNewColumnToAttendee < ActiveRecord::Migration
  def change
  	add_column :attendees, :competition_id, :integer
  end
end
