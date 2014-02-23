class DevicesController < ApplicationController
  def index
    @devices = current_user.device if current_user
  end

  def create
    auth = request.env["omniauth.auth"]
    p auth
    if current_user.device != nil
      current_user.device.destroy
      flash[:alert] = "Deleted previous device."
    end
    bit = Device.new
    bit.user_id = current_user.id
    p bit.user_id
    bit.provider = auth['provider']
    p bit.provider
    bit.uid = auth['uid']
    p bit.uid
    bit.oauth_token = auth['credentials']['token']
    p bit.oauth_token
    bit.oauth_verifier = params['oauth_verifier']
    p bit.oauth_verifier
    bit.oauth_token_secret = auth['credentials']['secret']
    p bit.oauth_token_secret

    now =  Time.now()
    bit.lastUpdated = (now - 7.days)



    if bit.save
      flash[:success] = "Device pairing successful."
    else 
      flash[:error] = "Device unsuccessful."
    end
    redirect_to root_path
  end

  def destroy
    current_user.device = nil
    flash[:success] = "Successfully destroyed device."
    redirect_to root_path
  end

  def show
    @device = Device.find(params[:id])

  end
end
