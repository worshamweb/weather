class Forecast < ApplicationRecord
  attr_accessor :from_cache
  attribute :forecast, :json

  validates :zip_code, presence: true, uniqueness: true
  validates :forecast, presence: true

  def self.find_or_fetch_from_api(zip_code)
    cache_key = "#{zip_code}"
    cached_value = Rails.cache.read(cache_key)
    cached_value.from_cache = true if cached_value.present?

    if cached_value
      cached_value
    else
      from_cache = false
      weather_api_data = WeatherApiService.fetch(zip_code)
      new_record = find_or_create_by(zip_code: zip_code, forecast: weather_api_data)
      new_record.from_cache = false
      Rails.cache.write(cache_key, new_record, expires_in: 30.minutes)
      new_record
    end
  end

end
