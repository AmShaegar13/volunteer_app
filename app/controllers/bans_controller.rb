class BansController < ApplicationController
  def index
    limit = params[:limit] ? params[:limit] : 15
    @bans = Ban.ordered_by_end.limit(limit)
  end
end
