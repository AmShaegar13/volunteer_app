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
    errors = []
    user = if params[:ban][:user][:name].empty?
             User.find params[:ban][:user][:id]
           else
             begin
               User.new name: Summoner.find_by_name(params[:ban][:user][:name]).name
             rescue ActiveResource::ResourceNotFound
               errors << 'Summoner not found.'
               nil
             end
           end
    begin
      Ban.create! params.require(:ban).permit(:duration, :user, :reason, :link).merge(user: user)
    rescue => ex
      errors << ex.message
    end
    flash[:error] = errors
    redirect_to :root
  end
end
