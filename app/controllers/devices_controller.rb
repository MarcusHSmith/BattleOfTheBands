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
    bit.provider = auth['provider']
    bit.uid = auth['uid']
    bit.oauth_token = params['oauth_token']
    bit.oauth_verifier = params['oauth_verifier']
    if bit.save
      flash[:notice] = "Device pairing successful."
    else 
      flash[:alert] = "Device unsuccessful."
    end
    redirect_to root_path
  end

  def destroy
    current_user.device = nil
    redirect_to root_path, :notice => "Successfully destroyed device."
  end

  def show
    @device = Device.find(params[:id])
  end
end
