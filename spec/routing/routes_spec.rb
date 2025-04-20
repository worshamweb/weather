require 'rails_helper'

RSpec.describe "Routing", type: :routing do
  describe "GET /index" do
    it "routes GET /forecast to forecasts#index" do
      expect(get: '/forecast').to route_to("forecasts#index")
    end
  end

  describe "GET /search" do
    it "routes GET /search to forecasts#search" do
      expect(get: '/search').to route_to("forecasts#search")
    end
  end

end
