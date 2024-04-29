class WeatherForecastsController < ApplicationController
  before_action :set_address, only: :forecast

  def index
  end

  def forecast

  end

  private

  def set_address
    @address = params[:address]
  end
end
