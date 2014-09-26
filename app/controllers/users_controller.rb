class UsersController < ApplicationController
  def index
    redirect_to :root
  end

  def show
    @user = User.find(params[:id])
    @bans = @user.bans.reverse
    @blank_ban = Ban.new
  end

  def search
    name = params.require(:search_query) rescue nil
    user = User.find_by_name(name)
    if user
      redirect_to user_path(user)
    else
      flash[:error] = "Summoner '#{name}' not found."
      redirect_to :root
    end
  end
end
