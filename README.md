# README

* Overview
  * This is a simple app that uses google places autocomplete to take an address entry and queries www.weatherapi.com 
  to present a 7 day forecast.  Forecast data from the API is cached by US Zip Code for 30 minutes using Rails memory caching. 
  There is a thermometer icon in the "Current Conditions" header section that indicates whether the forecast data is 
  cached or fresh. A full thermometer icon means cached, a low thermometer icon means freshly updated.


* Requirements
  * Ruby 3.4.2
  * Rails 8.02
  * SQLite3
  * jQuery 3.7.1
  * Bootstrap 5.3
  * Bundler

* Clone:
  * `git clone https://github.com/worshamweb/weather.git`
  * cd weather
  * bundle install
  * rails db:prepare
  * rails s
  * http://localhost:3000/forecast/

* Testing
  * This app uses Rspec, Webmock, Capybara Selenium Drivers and Cypress
  * run `rspec spec` for tests
  * default configuration is selenium headless driver. To change, edit `Capybara.default_driver = :selenium_chrome_headless`
  in `spec/rails_helper.rb`

* Troubleshooting
  * App uses memory cache by default. To enable SSD caching:
    * Change `config.cache_store = :memory_store` to `config.cache_store = :solid_cache_store` in `config/environments/development.rb`
    * Run `./bin/rails db:setup:cache` to create cache database
  
