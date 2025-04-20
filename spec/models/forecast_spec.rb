require 'rails_helper'

RSpec.describe Forecast, type: :model do
  describe "Validations" do
    describe "zip_code" do
      it "validates presence of zip_code" do
        forecast = Forecast.new(forecast: "test")
        forecast.valid?
        expect(forecast.errors[:zip_code]).to include("can't be blank")

        forecast.zip_code = "12345"
        forecast.valid?
        expect(forecast.errors[:zip_code]).to be_empty
      end
      it "validates uniqueness of zip_code" do
        original = Forecast.create(zip_code: "12345", forecast: "test")
        duplicate = Forecast.new(zip_code: "12345", forecast: "something else")
        duplicate.valid?
        expect(duplicate.errors[:zip_code]).to include("has already been taken")
      end
    end

    describe "forecast" do
      it "validates presence of forecast" do
        forecast = Forecast.new(zip_code: "12345")
        forecast.valid?
        expect(forecast.errors[:forecast]).to include("can't be blank")
      end
    end
  end

  describe "Accessors" do
    it "has a attribute accessor for has_cache" do
      forecast = Forecast.new(zip_code: "12345", forecast: "test")
      expect(forecast.respond_to?(:from_cache)).to be true
    end
  end

  describe "#find_or_fetch_from_api" do
    before do
      # Mock successful API Request using WeatherApiService
      stub_request(:get, "https://api.weatherapi.com/v1/forecast.json")
        .with(query: hash_excluding({}))
      .to_return(
          status: 200,
          headers: {'Content-Type' => 'application/json'},
          body: {"from_api": "This was returned from the API call"}.to_json
      )
    end

    after(:each) do
      Rails.cache.clear
      Forecast.delete_all
    end

    it "accepts only one parameter" do
      method = Forecast.method(:find_or_fetch_from_api)
      expect(method.arity).to eq(1)
    end

    context "when cached" do
      it "returns a Forecast from cache if it exists" do
        zip_code = "12345"
        forecast = Forecast.create(zip_code: zip_code, forecast: "This should be cached")
        Rails.cache.write(zip_code, forecast, expires_in: 3.minutes)
        cached_forecast = Forecast.find_or_fetch_from_api(zip_code)
        expect(cached_forecast.forecast).to eq(forecast.forecast)
      end
    end

    context "when cache is expired or missing" do
      it "Returns a Forecast from the API if it does not exist in cache" do
        zip_code = "54321"
        forecast = Forecast.find_or_fetch_from_api(zip_code)
        expect(forecast.zip_code).to eq(zip_code)
        expect(forecast.forecast["from_api"]).to eq("This was returned from the API call")
      end

    end

  end
end
