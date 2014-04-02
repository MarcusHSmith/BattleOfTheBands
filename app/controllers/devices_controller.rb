class DevicesController < ApplicationController
  def index
    @devices = current_user.device if current_user
  end

  def create
    auth = request.env["omniauth.auth"]
    if current_user.device != nil
      current_user.device.destroy
      flash[:alert] = "Deleted previous device."
    end
    bit = Device.new
    bit.user_id = current_user.id
    bit.provider = auth['provider']
    bit.uid = auth['uid']
    bit.oauth_token = auth['credentials']['token']
    bit.oauth_verifier = params['oauth_verifier']
    bit.oauth_token_secret = auth['credentials']['secret']
    now =  Time.now()
    bit.lastUpdated = (now - 7.days)
    if bit.save
      flash[:success] = "Device pairing successful."
    else 
      flash[:error] = "Device unsuccessful."
    end
    redirect_to current_user
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
