class Competition < ActiveRecord::Base
  attr_accessible :title, :user_id
  validates :title, length: {maximum: 50 }
end
