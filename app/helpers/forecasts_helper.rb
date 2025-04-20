module ForecastsHelper
  def day_of_week(date)
    parsed_date = Date.parse(date)
    if parsed_date.today?
      "Today"
    elsif parsed_date.tomorrow?
      "Tomorrow"
    else
      parsed_date.strftime('%A')
    end
  end
end
