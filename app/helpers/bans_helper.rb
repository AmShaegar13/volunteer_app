module BansHelper
  BAN_COLORS = %w[#b6d7a8 #ffe599 #f9cb9c #ea9999 #cc4125]

  def color_by_duration(duration)
    BAN_COLORS[Ban::ALLOWED_DURATIONS.index(duration)]
  end

  # FIXME when yap supports paging
  def link_to_prev_page
    params[:page] ||= 1
    link_to '<', request.params.update({ page: params[:page].to_i-1 }) unless params[:page].to_i == 1
  end

  def link_to_next_page
    link_to '>', request.params.update({ page: params[:page].to_i+1 }) unless params[:page].to_i == Ban.with_user_and_creator.last_page(params)
  end

  def link_to_first_page
    params[:page] ||= 1
    link_to '<<', request.params.update({ page: nil }) unless params[:page].to_i == 1
  end

  def link_to_last_page
    link_to '>>', request.params.update({ page: Ban.with_user_and_creator.last_page(params) }) unless params[:page].to_i == Ban.with_user_and_creator.last_page(params)
  end
end
