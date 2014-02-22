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
        #:user_id => @device.uid
      )
      now =  Time.now()
      if @user.lastUpdated == nil
        p 'LastUpdated nil compensation'
        @user.lastUpdated = now
      end
      last = @user.lastUpdated


      while now.day > last.day
        day = client.activities_on_date last.strftime("%Y-%m-%d")
        day = day['summary']['steps']
        now = now + 1.days
        p day
        @user.year = @user.year.unshift(day)
      end
      #doesn't include today
      if now.day != last.day
        @user.today_steps = (client.activities_on_date 'today')['summary']['steps']
        @user.year.unshift(@user.today_steps)
      else
        @user.today_steps = (client.activities_on_date 'today')['summary']['steps']
        @user.year[0] = @user.today_steps
      end

      p @user.today_steps
      p @user.year
      @user.lastUpdated = now

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
      flash[:success] = "Welcome to the Sample App!"
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