module ApplicationHelper
  def format_duration(d)
    case d
      when -1 then 'permanent'
      when 1 then "#{d} day"
      else "#{d} days"
    end
  end
end
