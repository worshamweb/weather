require 'rails_helper'

RSpec.describe "_current_conditions.html.erb", type: :view do
  let(:forecast_data) { Forecast.find_or_fetch_from_api('12345') }
  before do
    stub_request(:get, "https://api.weatherapi.com/v1/forecast.json")
      .with(query: hash_excluding({}))
      .to_return(
        status: 200,
        headers: {'Content-Type' => 'application/json'},
        body: File.read("spec/fixtures/weather_api_response.json")
      )
    render partial: 'forecasts/current_conditions', locals: { forecast_data: forecast_data }
  end

  it "displays the current temperature" do
    expect(rendered).to have_css('span.temp-preference.imperial.current-temp', text: "66.9&deg")
    expect(rendered).to have_css('span.temp-preference.metric.current-temp', text: "19.4&deg")
  end

  it "displays the correct icon for current conditions" do
    expect(rendered).to have_css('img#current-weather-icon[src*="cdn.weatherapi.com/weather/64x64/day/113.png"]')
  end

  it "displays the correct description for current conditions" do
    expect(rendered).to have_css('li#current_condition_text', text: "Sunny")
  end

  it "displays the correct description for current Feels Like conditions" do
    expect(rendered).to have_css('li.value.temp-preference.imperial.feels-like', text: "66.9&deg")
    expect(rendered).to have_css('li.value.temp-preference.metric.feels-like', text: "19.4&deg")
  end

  it "displays the correct description for current Humidity conditions" do
    expect(rendered).to have_css('li.value.humidity', text: "17%")
  end

  it "displays the correct description for current UV Index" do
    expect(rendered).to have_css('li#uv-index', text: "1.8")
  end

  it "displays the correct description for current Wind Speed conditions" do
    expect(rendered).to have_css('li.value.temp-preference.imperial.wind', text: "NNW 13.0 mph")
    expect(rendered).to have_css('li.value.temp-preference.metric.wind', text: "NNW 20.9 kmh")
  end

  it "displays the correct description for current Visibility conditions" do
    expect(rendered).to have_css('li.value.temp-preference.imperial.visibility', text: "9.0 miles")
    expect(rendered).to have_css('li.value.temp-preference.metric.visibility', text: "16.0 km")
  end

  it "displays the correct description for current Barometric Pressure" do
    expect(rendered).to have_css('li.value.temp-preference.imperial.pressure', text: "30.28 in")
    expect(rendered).to have_css('li.value.temp-preference.metric.pressure', text: "1025.0 mb")
  end

  it "displays the correct description for today's Sunrise" do
    expect(rendered).to have_css('li#sunrise', text: "06:09 AM")
  end

  it "displays the correct description for today's Sunset" do
    expect(rendered).to have_css('li#sunset', text: "07:41 PM")
  end
end
