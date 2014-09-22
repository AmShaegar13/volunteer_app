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
end
