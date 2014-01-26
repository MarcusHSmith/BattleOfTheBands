class Attendee < ActiveRecord::Base
  attr_accessible :competition_id, :user_id

  belongs_to :competition
  belongs_to :user

  validates :competition_id, :uniqueness => { :scope => :user_id }


	has_many :attendees, :dependent => :destroy
	has_many :users, :through => :attendees
end
