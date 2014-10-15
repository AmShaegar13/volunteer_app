class BansController < ApplicationController
  def index
    limit = params[:limit] ? params[:limit] : 25
    @bans = Ban.order(created_at: :desc).limit(limit)
    @autocomplete_users = User.select(:name).order(updated_at: :desc).map(&:name)
    self.new
  end

  def new
    @blank_ban = Ban.new
  end

  def create
    user_params = params.require(:ban).require(:user).permit(:id, :name, :main)
    user = User.find_or_create_by(user_params.slice(:id, :name).merge(tool_user: current_user))
    raise ArgumentError, "User '#{user_params[:name]}' does not exist." if user.nil?
    if user_params.key?(:main) && !user_params[:main].blank?
      main = User.find_or_create_by(name: user_params[:main], banned_by: current_user)
      unless main.nil?
        user.update_main main, current_user
      else
        flash[:notice] = "User '#{user_params[:main]}' does not exist."
      end
    end
    ban = Ban.create!(params.require(:ban).permit(:duration, :reason, :link).merge(user: user))
    Action.create!(tool_user: current_user, action: 'create', reference: ban)
  rescue => ex
    flash[:error] = ex.message
  ensure
    redirect_to :root
  end
end
