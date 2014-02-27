class CompetitionsController < ApplicationController
  before_filter   :signed_in_user, only: [:index, :edit, :update, :destroy, :create, :attend]

  def index
    @competitions = Competition.all
  end

  def show
    @competition = Competition.find(params[:id])
    @user = User.find(current_user.id)
    #@competition.users[0].today_steps
    
    @competition.users.sort_by!{|user| -user.daily.first(7).sum}
    for comp in @competition.users
      p comp.name
      p comp.daily

    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @competition }
    end
  end


  def new
    @competition = Competition.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @competition }
    end
  end

  def edit
    @competition = Competition.find(params[:id])
  end

  def create
    @competition = Competition.new(params[:competition])
    @competition.user_id = current_user.id
    current_user.competitions << @competition
    if @competition.save
      flash[:success] = "Competition created"
      redirect_to @competition
    else
      render 'static_pages/home'
    end
  end

  def update
    @competition = Competition.find(params[:id])
    respond_to do |format|
      if @competition.update_attributes(params[:competition])
        format.html { redirect_to @competition, notice: 'Competition was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @competition = Competition.find(params[:id])
    @competition.destroy

    respond_to do |format|
      format.html { redirect_to competitions_url }
      format.json { head :no_content }
    end
  end

  def attend
    p current_user.daily
    @competition = Competition.find(params[:id])
    if @competition.users.include?(current_user)
      flash[:error] = "You're already attending this competition."
    elsif current_user.daily == []
      flash[:error] = "You must have a working device to compete."
    else
      current_user.competitions << @competition
      flash[:success] = "Attending competition!"
    end
    redirect_to @competition
  end

  def withdraw
    @competition    = Competition.find(params[:id])
    p @competition
    attendee = Attendee.find_by_user_id_and_competition_id(current_user.id, @competition.id)
    if attendee.blank?
      flash[:error] = "No current attendees"
    else
      attendee.delete
      flash[:success] = 'You are no longer attending this competition.'
    end
    p attendee
    redirect_to @competition
  end


  private
    def competition_params
      params.require(:competition).permit(:content)
    end

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end

    def correct_user
      if (Event.find(params[:id]).user_id != current_user.id and !current_user.admin?)
        redirect_to competitions_path
        flash[:error] = "You do not own this competition"
      end
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
