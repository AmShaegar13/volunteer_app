class BansController < ApplicationController
  def index
    limit = params[:limit] ? params[:limit] : 15
    @bans = Ban.ordered_by_end.limit(limit)
  end

  def new
    @ban = Ban.new
  end

  def create
    user = if params[:ban][:user][:name].empty?
             User.find params[:ban][:user][:id]
           else
             User.new params.require(:ban).require(:user).permit(:name)
           end
    Ban.create! params.require(:ban).permit(:duration, :user, :reason, :link).merge(user: user)
    redirect_to :root
  end
end
