class Competition < ActiveRecord::Base
  attr_accessible :title, :user_id
  belongs_to :user
  validates :title, length: {maximum: 50 }
end
