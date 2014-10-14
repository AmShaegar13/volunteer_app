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
    user = User.find_or_create_by params.require(:user).permit(:name)
    redirect_to user
  end

  def search
    name = params.require(:search_query) rescue nil
    respond_to do |format|
      format.json do
        users = User.search(name)
        users = users.select(:name).map(&:name) unless users.empty?
        respond_with users
      end

      format.html do
        user = User.find_by(name: name)
        if user.nil?
          summoner = Summoner.find_by_name(name)
          if summoner
            user = User.find_by(id: summoner.id)
            if user.nil?
              flash[:error] = "Summoner '#{name}' not banned yet."
              flash[:create_user] = name
            end
          else
            flash[:error] = "Summoner '#{name}' does not exist."
          end
        end

        redirect_to(user.nil? ? :root : user_path(user))
      end
    end
  end
end
