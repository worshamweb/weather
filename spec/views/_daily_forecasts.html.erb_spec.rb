require 'rails_helper'
require_relative '../../app/helpers/forecasts_helper'

RSpec.describe "_daily_forecasts.html.erb", type: :view do
  include ForecastsHelper
  let(:forecast_data) { Forecast.find_or_fetch_from_api('12345') }
  let(:days) {Capybara.string(rendered).all('ul.seven-day-forecast > li.days')}
  before do
    stub_request(:get, "https://api.weatherapi.com/v1/forecast.json")
      .with(query: hash_excluding({}))
      .to_return(
        status: 200,
        headers: {'Content-Type' => 'application/json'},
        body: File.read("spec/fixtures/weather_api_response.json")
      )
    @daily_forecasts = forecast_data.forecast["forecast"]["forecastday"]
    render partial: 'forecasts/daily_forecasts', locals: { daily_forecasts: @daily_forecasts }
  end

  context "Verifying 7 day forecasts" do
    it "displays the forecast for seven days" do
      expect(days.length).to eq(7)
    end

    it "displays the correct forecast icon for each day" do
      days.each_with_index do |day, index|
        weather_icon = day.find('ul.day li.icon img')['src']
        forecats_icon = @daily_forecasts[index]['day']['condition']['icon']
        expect(weather_icon).to eq(forecats_icon)
      end
    end

    it "displays the correct high temp for each day" do
      days.each_with_index do |day, index|
        expect(day.find('li.high-temp span.temp-preference.imperial').text).to eq("#{@daily_forecasts[index]['day']['maxtemp_f']}&deg")
        expect(day.find('li.high-temp span.temp-preference.metric').text).to eq("#{@daily_forecasts[index]['day']['maxtemp_c']}&deg")
      end
    end

    it "displays the correct low temp for each day" do
      days.each_with_index do |day, index|
        expect(day.find('li.low-temp span.temp-preference.imperial').text).to eq("#{@daily_forecasts[index]['day']['mintemp_f']}&deg")
        expect(day.find('li.low-temp span.temp-preference.metric').text).to eq("#{@daily_forecasts[index]['day']['mintemp_c']}&deg")
      end
    end
  end
end
