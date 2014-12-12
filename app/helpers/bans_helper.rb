module BansHelper
  BAN_DURATIONS = [1, 3, 7, 14, 0]
  BAN_COLORS = %w[#b6d7a8 #ffe599 #f9cb9c #ea9999 #cc4125]

  def increase_duration(duration)
    result = BAN_DURATIONS.at BAN_DURATIONS.index(duration)+1
    result || duration
  end

  def color_by_duration(duration)
    BAN_COLORS[BAN_DURATIONS.index(duration)]
  end

  # FIXME when yap supports paging
  def link_to_prev_page
    params[:page] ||= 1
    link_to '<', page: params[:page].to_i-1 unless params[:page].to_i == 1
  end

  def link_to_next_page
    last = (Ban.count / 25.0).ceil
    link_to '>', page: params[:page].to_i+1 unless params[:page].to_i == last
  end

  def link_to_first_page
    params[:page] ||= 1
    link_to '<<' unless params[:page].to_i == 1
  end

  def link_to_last_page
    last = (Ban.count / 25.0).ceil
    link_to '>>', page: last unless params[:page].to_i == last
  end
end
