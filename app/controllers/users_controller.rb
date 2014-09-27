class UsersController < ApplicationController
  def index
    redirect_to :root
  end

  def show
    @user = User.find(params[:id])
    @bans = @user.bans.reverse
    @blank_ban = Ban.new
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
          user = User.find_by(id: summoner.id) unless summoner.nil?
        end

        if user
          redirect_to user_path(user)
        else
          flash[:error] = "Summoner '#{name}' not found."
          redirect_to :root
        end
      end
    end
  end
end
