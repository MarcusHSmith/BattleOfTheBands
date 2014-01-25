class User < ActiveRecord::Base
  attr_accessible :email, :name, :points
  has_many :competitions
end
