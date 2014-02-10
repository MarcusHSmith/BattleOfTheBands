class DevicesController < ApplicationController
  def index
    @devices = current_user.device if current_user
  end

  def create
    auth = request.env["omniauth.auth"]
    p params
    bit = Device.new
    bit.user_id = current_user.id
    bit.provider = auth['provider']
    bit.uid = auth['uid']
    bit.oauth_token = params['oauth_token']
    bit.oauth_verifier = params['oauth_verifier']
    flash[:notice] = "Device successful."
    redirect_to root_path
  end

  def destroy
    @device = Device.find(params[:id])
    @device.destroy
    redirect_to root_path, :notice => "Successfully destroyed device."
  end

  def show
    @device = Device.find(params[:id])
  end
end
