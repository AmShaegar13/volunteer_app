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
    Ban.transaction do
      user_params = params.require(:ban).require(:user).permit(:id, :name, :main)
      user = find_or_create_user user_params
      raise ArgumentError, "User '#{user_params[:name]}' does not exist." if user.nil?

      if user_params.key?(:main) && !user_params[:main].blank?
        main = find_or_create_user(name: user_params[:main])
        unless main.nil?
          User.transaction do
            user.main = main
            user.save!
            Action.create!(tool_user: current_user, action: 'set_main', reference: user)
          end
        else
          flash[:notice] = "User '#{user_params[:main]}' does not exist."
        end
      end

      ban = Ban.create!(params.require(:ban).permit(:duration, :reason, :link).merge(user: user))
      Action.create!(tool_user: current_user, action: 'create', reference: ban)
    end
  rescue => ex
    logger.error ex.message
    logger.error ex.backtrace.to_yaml
    flash[:error] = ex.message
  ensure
    redirect_to :root
  end
end
