class AddColumnYearToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :daily, :string
  end
end
