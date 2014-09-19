module BansHelper
  BAN_DURATIONS = [1, 3, 7, 14, -1]

  def increase_duration(duration)
    result = BAN_DURATIONS.at BAN_DURATIONS.index(duration)+1
    result || duration
  end
end
