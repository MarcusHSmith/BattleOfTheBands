class Device < ActiveRecord::Base
  attr_accessible :user_id, :provider, :uid, :oauth_token, :oauth_token_secret

  belongs_to :user

  def fitbit_data
    #auth = request.env["omniauth.auth"]

  end
end
