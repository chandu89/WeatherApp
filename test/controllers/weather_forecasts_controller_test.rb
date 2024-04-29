require "test_helper"

class WeatherForecastsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get weather_forecasts_index_url
    assert_response :success
  end
end
