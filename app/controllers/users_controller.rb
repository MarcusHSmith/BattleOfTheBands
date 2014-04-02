class UsersController < ApplicationController

  before_filter   :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter   :correct_user,  only:[:edit, :update]
  before_filter   :admin_user,    only: :destroy

  def show
    @user = User.find(params[:id])
    if (@user.device != nil)
      @device = @user.device
      client = Fitgem::Client.new(
        :consumer_key => 'b4aacb5c2c8c43e2a6873877cd2ad9b1',
        :consumer_secret => '88bd78fc86d84d6c9aa7b1c0b8d4511f',
        :token => @device.oauth_token,
        :secret => @device.oauth_token_secret
      )
      now =  Time.now()
      last = @device.lastUpdated
      while now.to_date > last.to_date
        day = client.activities_on_date last.strftime("%Y-%m-%d")
        break if day['errors'] != nil
        day = day['summary']['steps']
        last = last + 1.days
        @user.daily = @user.daily.unshift(day)
      end
      day = (client.activities_on_date 'today')
      if day['errors'] == nil
        @user.today_steps = day['summary']['steps']
        if now.day != @device.lastUpdated.in_time_zone("Pacific Time (US & Canada)").day
          @user.daily.unshift(@user.today_steps)
        else
          @user.daily[0] = @user.today_steps
        end
      end

      
      @device.lastUpdated = now
      @user.device.errors.full_messages
      @user.device.save
      @user.device.errors.full_messages

      if @user.save(validate: false)
        p "Updated"
      else 
        p "Failed to Update"
      end
    end
    @competitions = @user.competitions.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Battle of The Bands! Now link a device to compete"
      redirect_to @user
    else
      render 'new'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user? (@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end