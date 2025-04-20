class Forecast < ApplicationRecord
  attr_accessor :from_cache #this is the flag to indicate if the record is fetched from cache or not
  attribute :forecast, :json # Simplifies storing/working with JSON data in SQLite3

  validates :zip_code, presence: true, uniqueness: true
  validates :forecast, presence: true

  def self.find_or_fetch_from_api(zip_code)
    cache_key = "#{zip_code}"
    cached_value = Rails.cache.read(cache_key)
    cached_value.from_cache = true if cached_value.present?

    # If the record exists in cache, return from there. Otherwise fetch from API and cache it.
    if cached_value
      cached_value
    else
      weather_api_data = WeatherApiService.fetch(zip_code)
      new_record = find_or_create_by(zip_code: zip_code, forecast: weather_api_data)
      new_record.from_cache = false
      Rails.cache.write(cache_key, new_record, expires_in: 30.minutes)
      new_record
    end
  end

end
