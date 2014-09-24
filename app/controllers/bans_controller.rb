class BansController < ApplicationController
  def index
    limit = params[:limit] ? params[:limit] : 25
    @bans = Ban.order(created_at: :desc).limit(limit)
    @autocomplete_users = User.all.select(:name).order(id: :desc).map(&:name)
    self.new
  end

  def new
    @blank_ban = Ban.new
  end

  def create
    user = User.find_or_create(params.require(:ban).require(:user).permit(:id, :name))
    Ban.create!(params.require(:ban).permit(:duration, :reason, :link).merge(user: user)) do |ban|
      Action.create!(tool_user: current_user, action: 'create', reference: ban)
    end
  rescue => ex
    flash[:error] = ex.message
  ensure
    redirect_to :root
  end
end
