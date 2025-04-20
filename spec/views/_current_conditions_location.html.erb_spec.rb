require 'rails_helper'

RSpec.describe "_current_conditions_location.html.erb", type: :view do
  it "displays the zip code and thermometer icon" do
    render partial: "forecasts/current_conditions_location", locals: {zip_code: "54321", from_cache: true }
    expect(rendered).to include("Current Conditions in 54321")
  end
  context "cache indicator (thermometer icon)" do
    it "displays a full thermometer icon when from_cache is true" do
      render partial: "forecasts/current_conditions_location", locals: {zip_code: "54321", from_cache: true }
      expect(rendered).to include("bi-thermometer-high")
      expect(rendered).not_to include("bi-thermometer-low")
    end
    it "displays a low thermometer icon when from_cache is false" do
      render partial: "forecasts/current_conditions_location", locals: {zip_code: "54321", from_cache: false }
      expect(rendered).to include("bi-thermometer-low")
      expect(rendered).not_to include("bi-thermometer-high")
    end
  end
end
