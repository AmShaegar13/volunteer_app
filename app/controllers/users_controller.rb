class UsersController < ApplicationController
  def index
    redirect_to :root
  end

  def show
    @user = User.find(params[:id])
    @bans = @user.bans.reverse
    @blank_ban = Ban.new
  end

  def create
    user = find_or_create_user params.require(:user).permit(:name)
    redirect_to user
  end

  def search
    name = params.require(:search_query) rescue nil
    respond_to do |format|
      format.json do
        users = User.search(name)
        users = users.select(:name, :region).map { |user| '%s (%s)' % [user.name, user.region] } unless users.empty?
        respond_with users
      end

      format.html do
        # TODO consider duplicate names
        user = User.find_by(name: name)
        if user.nil?
          flash[:error] = "Summoner '#{name}' not banned yet."
        end

        redirect_to(user.nil? ? :root : user_path(user))
      end
    end
  end
end
