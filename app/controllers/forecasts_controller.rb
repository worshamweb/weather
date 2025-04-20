class ForecastsController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :search_params_missing

  def index
  end

  def search
    if search_params.present?
      @forecast_data = Forecast.find_or_fetch_from_api(search_params)
      @daily_forecasts = @forecast_data.forecast["forecast"]["forecastday"]
      respond_to do |format|
        format.js { render :search }
      end
    else
      @zipcode_missing = "Please enter a valid zip code"
      respond_to do |format|
        format.js { render :search }
      end
    end
  end

  private

  # Only allow zip_code
  def search_params
    params.require(:zip_code)
  end

  def search_params_missing
    @search_error_message = "Zipcode for that location is not found. please enter another address, city or zip code for weather forecast"
    respond_to do |format|
      format.js { render :search_error }
    end
  end
end
