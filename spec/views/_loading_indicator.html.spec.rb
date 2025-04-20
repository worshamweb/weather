require 'rails_helper'

RSpec.describe "_loading_indicator.html", type: :view do
  it "displays the loading indicator" do
    render partial: 'forecasts/loading_indicator'
    expect(rendered).to have_css('div#loading-spinner')
    expect(rendered).to have_css('div.spinner-border')
    expect(rendered).to have_css('span.visually-hidden')
  end
end
