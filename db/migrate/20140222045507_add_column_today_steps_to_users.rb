class AddColumnTodayStepsToUsers < ActiveRecord::Migration
  def change
  	  	add_column :users, :today_steps, :integer
  end
end
