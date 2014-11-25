class BansController < ApplicationController
  def index
    limit = params[:limit] ? params[:limit] : 25
    @bans = Ban.order(created_at: :desc).limit(limit)
    self.new
  end

  def new
    @blank_ban = Ban.new
  end

  def create
    ban_params = params.require(:ban).permit(:duration, :reason, :link)
    user_params = params.require(:ban).require(:user).permit(:id, :name, :main)
    region = ban_params[:link].match(/forums\.(.+?)\.leagueoflegends\.com/)[1]
    user_params.merge!(region: region)

    Ban.transaction do
      user = find_or_create_user user_params

      if user_params.key?(:main) && !user_params[:main].blank?
        main = find_or_create_user(name: user_params[:main], region: region)
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

      ban = Ban.create!(ban_params.merge(user: user))
      Action.create!(tool_user: current_user, action: 'create', reference: ban)
    end
  rescue => ex
    logger.debug ex.message
    logger.debug ex.backtrace
    flash[:error] = ex.message
  ensure
    redirect_to :root
  end
end
