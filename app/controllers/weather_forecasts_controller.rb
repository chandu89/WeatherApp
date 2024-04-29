class WeatherForecastsController < ApplicationController
  before_action :set_address, only: :index

  def index
  end

  private

  def set_address
    @address = params[:address]
  end
end
