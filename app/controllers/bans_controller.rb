class BansController < ApplicationController
  def index
    limit = params[:limit] ? params[:limit] : 15
    @bans = Ban.ordered_by_end.limit(limit)
    self.new
  end

  def new
    @ban = Ban.new
  end

  def create
    user = User.find_or_create params.require(:ban).require(:user).permit(:id)[:id], params.require(:ban).require(:user).permit(:name)[:name]

    begin
      Ban.create! params.require(:ban).permit(:duration, :user, :reason, :link).merge(user: user)
    rescue => ex
      flash[:error] = ex.message
    end

    redirect_to :root
  end
end
