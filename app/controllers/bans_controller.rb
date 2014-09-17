class BansController < ApplicationController
  def index
    limit = params[:limit] ? params[:limit] : 15
    @bans = Ban.ordered_by_end.limit(limit)
  end

  def new
    @ban = Ban.new
  end

  def create
    user = User.new params.require(:ban).require(:user).permit(:name)
    Ban.create! params.require(:ban).permit(:duration, :user, :reason, :link).merge(user: user)
    redirect_to :root
  end
end
