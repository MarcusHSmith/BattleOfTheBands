class StaticPagesController < ApplicationController
  def home
  	@competition = current_user.competitions.build if signed_in?
  end
  def help
  end
  def index
  end
end
