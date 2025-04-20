require 'rails_helper'
require 'capybara/rspec'

RSpec.feature "Forecast Landing Page Interactions", type: :feature do
  before do
    stub_request(:get, "https://api.weatherapi.com/v1/forecast.json")
      .with(query: hash_excluding({}))
      .to_return(
        status: 200,
        headers: { 'Content-Type' => 'application/json' },
        body: File.read("spec/fixtures/weather_api_response.json")
      )
  end

  scenario 'User enters valid data for address search' do
    visit forecast_path

    # Make sure the page loads and has the place picker input field
    expect(page).to have_css('gmpx-place-picker')

    # Enter a valid zip code and click enter
    find('gmpx-place-picker').click.send_keys('89142').send_keys(:enter)
    find('gmpx-place-picker').send_keys(:enter)

    # Make sure the page updates and has valid content
    expect(page).to have_css('span.current-conditions-in-location-message', text: "Current Conditions in 89142")
    expect(page).to have_css('img#current-weather-icon[src*="cdn.weatherapi.com/weather/64x64/day/113.png"]')
    expect(page).to have_css('li.days', count: 7)
  end

  scenario 'Zip code not found error' do
    stub_request(:get, "/search")
      .with(query: 'zip_code=1234567890')
      .to_return(
        status: 200
      )

    visit forecast_path

    page.execute_script("$('gmpx-place-picker').trigger('gmpx-placechange')")
    expect(page).to have_css('div#gmpx-no-match-error', visible: true, text: "Can not find a Zip Code for that selection. Please enter a different address, city or zip code")
  end

  scenario 'User can change between Imperial (fahrenheit/mph/inches) and Metric (celsius/kph/mb) units' do
    visit forecast_path

    # Enter a valid zip code and click enter
    find('gmpx-place-picker').click.send_keys('89142').send_keys(:enter)
    find('gmpx-place-picker').send_keys(:enter)

    # Default setting is imperial
    expect(page).to have_css('span.temp-preference.imperial.current-temp', text: "66.9", visible: true)
    expect(page).to have_css('span.temp-preference.metric.current-temp', text: "19.4", visible: false)

    # Change to metric using settings dropdown
    find('#dropdownMenuButton').click
    find('#set-preference-metric', text: "Celsius").click

    # Page should now show metric temps and hide Fahrenheit
    expect(page).to have_css('span.temp-preference.metric.current-temp', text: "19.4", visible: true)
    expect(page).to have_css('span.temp-preference.imperial.current-temp', text: "66.9", visible: false)

  end

  scenario 'User can change from Default Imperial (fahrenheit/mph/inches) to Metric (celsius/kph/mb) an back' do
    visit forecast_path

    # Change from imperial to metric and confirm it is set in local storage
    find("#dropdownMenuButton").click
    find(".dropdown-menu").find('li', text: "Celsius").click
    expect(page.evaluate_script("localStorage.getItem('temperatureSettings')")).to eq("metric")

    # Change from metric to imperial and confirm it is set in local storage
    find("#dropdownMenuButton").click
    find(".dropdown-menu").find('li', text: "Fahrenheit").click
    expect(page.evaluate_script("localStorage.getItem('temperatureSettings')")).to eq("imperial")
  end

end
