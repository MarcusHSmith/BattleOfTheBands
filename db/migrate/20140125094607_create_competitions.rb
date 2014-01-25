class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.string :title
      t.integer :user_id

      t.timestamps
    end
  end
end
