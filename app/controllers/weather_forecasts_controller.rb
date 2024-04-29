class WeatherForecastsController < ApplicationController
  before_action :set_address, only: :forecast

  def index
  end

  def forecast
    if @address
      begin
        @weather_forecast = Rails.cache.fetch(@address, expires_in: 30.minutes) do
          geocode = GeocodeService.call(@address)
          WeatherService.call(geocode.latitude, geocode.longitude)          
        end
      rescue => e
        flash.alert = e.message
      end
    end
  end

  private

  def set_address
    @address = params[:address]
  end
end
