class UsersController < ApplicationController
  def index
    redirect_to :root
  end

  def show
    @user = User.includes(:smurfs, :bans).find(params[:id])
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
        respond_with(if params[:include_proposal]
          User.search_name_with_proposal(name)
        else
          User.search_name(name)
        end)
      end

      format.html do
        # TODO consider duplicate names
        user = User.find_by(name: name)
        if user.nil?
          flash[:error] = "Summoner '#{name}' not found."
        end

        redirect_to(user.nil? ? :root : user_path(user))
      end
    end
  end
end
