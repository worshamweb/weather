require 'rails_helper'
require 'webmock'

RSpec.describe "Forecasts", type: :request do
  describe "GET /index" do
    it "returns a success response" do
      get '/forecast'
      expect(response).to have_http_status(:success)
      expect(body).to include("forecast-container")
    end
  end

  describe "GET /search" do
    context "with valid params" do
      before { host! "localhost:3000" }
      before do
        Forecast.delete_all
        allow_any_instance_of(ForecastsController).to receive(:verify_authenticity_token).and_return(true)
        # Mock successful API Request using WeatherApiService
        stub_request(:get, "https://api.weatherapi.com/v1/forecast.json")
          .with(query: hash_excluding({}))
          .to_return(
            status: 200,
            headers: {'Content-Type' => 'application/json'},
            body: File.read("spec/fixtures/weather_api_response.json")
          )
      end
      it "returns a success response" do
        get "/search",
            params: { zip_code: '12345' },
            headers: {
              'Accept' => 'text/javascript',
              'Content-Type' => 'application/javascript'
            }
        expect(response).to have_http_status(:success)
        expect(response.body).to include('Current Conditions in 12345')
        expect(response.body).to include('<span class=\"temp-preference imperial current-temp\">66.9&deg<\/span>')
      end
    end

  end
end
