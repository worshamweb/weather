require 'rails_helper'
require 'spec_helper'
require 'weather_api_service'

RSpec.describe WeatherApiService do
  describe "#fetch" do
    context "Successful case" do
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
      it "returns a hash" do
        expect(WeatherApiService.fetch("12345")).to be_a(Hash)
      end
    end

    # The WeatherAPI Service documentation for errors
    # https://www.weatherapi.com/docs/
    describe "Fail cases" do
      context "400 Error - Bad Request" do
        before do
          stub_request(:get, "https://api.weatherapi.com/v1/forecast.json")
            .with(query: hash_excluding({}))
            .to_return(status: 400, body: "Bad Request")
        end
        it "raises an error on 400 response" do
          expect {
            WeatherApiService.fetch("12345")
          }.to raise_error(Errors::WeatherApiServiceError, "Bad or Malformed Request")
        end
      end
      context "401 Error - Unauthorized" do
        before do
          stub_request(:get, "https://api.weatherapi.com/v1/forecast.json")
            .with(query: hash_excluding({}))
            .to_return(status: 401, body: "Bad Request")
        end
        it "raises an error on 401 response" do
          expect {
            WeatherApiService.fetch("12345")
          }.to raise_error(Errors::WeatherApiServiceError, "API Key Missing or Invalid")
        end
      end
      context "403 Error - Forbidden" do
        before do
          stub_request(:get, "https://api.weatherapi.com/v1/forecast.json")
            .with(query: hash_excluding({}))
            .to_return(status: 403, body: "Bad Request")
        end
        it "raises an error on 403 response" do
          expect {
            WeatherApiService.fetch("12345")
          }.to raise_error(Errors::WeatherApiServiceError, "API Key Disabled or Does Not Have Access to Requested Resource")
        end
      end
      context "404 Error - Not Found" do
        before do
          stub_request(:get, "https://api.weatherapi.com/v1/forecast.json")
            .with(query: hash_excluding({}))
            .to_return(status: 404, body: "Not Found")
        end
        it "raises an error on 404 response" do
          expect {
            WeatherApiService.fetch("12345")
          }.to raise_error(Errors::WeatherApiServiceError, "Weather API 404 Not Found")
        end
      end
      context "All Other Server Errors" do
        before do
          stub_request(:get, "https://api.weatherapi.com/v1/forecast.json")
            .with(query: hash_excluding({}))
            .to_return(status: 500, body: "Not Found")
        end
        it "raises an error on unmanaged failures" do
          expect {
            WeatherApiService.fetch("12345")
          }.to raise_error(Errors::WeatherApiServiceError)
        end
      end
    end
  end
end
