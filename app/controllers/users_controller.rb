class UsersController < ApplicationController
  def index
    redirect_to :root
  end

  def show
    @user = User.find(params[:id])
    @bans = @user.bans.reverse
  end
end
