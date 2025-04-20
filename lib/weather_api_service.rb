require 'errors/weather_api_service_error'

class WeatherApiService

  def self.fetch(location)
    weather_api_url = Rails.configuration.api_config[:weather_api]
    params = {
      key: Rails.application.credentials.weather_api_key,
      q: location,
      days: 7,
      aqi: "no",
      alerts: "no"
    }
    url = Typhoeus::Request.new(weather_api_url, params: params).url
    response = Typhoeus::Request.get(url)

    if response.success?
      JSON.parse(response.body)
    else
      handle_error(response)
    end
  end

  private

  # For more details on errors responses returned from the API look under "API Error Codes":
  # https://www.weatherapi.com/docs/
  def self.handle_error(response)
    case response.code
    when 400
      raise Errors::WeatherApiServiceError, "Bad or Malformed Request"
    when 401
      raise Errors::WeatherApiServiceError, "API Key Missing or Invalid"
    when 403
      raise Errors::WeatherApiServiceError, "API Key Disabled or Does Not Have Access to Requested Resource"
    when 404
      raise Errors::WeatherApiServiceError, "Weather API 404 Not Found"
    else
      raise Errors::WeatherApiServiceError, "Weather API Response Error: #{response.code}"
    end
  end
end
