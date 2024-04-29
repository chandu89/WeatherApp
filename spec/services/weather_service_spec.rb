require 'rails_helper'

RSpec.describe WeatherService do
  describe '.call' do
    let(:latitude) { 40.7128 }
    let(:longitude) { -74.0060 }
    let(:api_key) { 'your_openweather_api_key' }

    before do
      allow(Rails.application.credentials).to receive(:openweather_api_key).and_return(api_key)
    end

    context 'when the API request is successful' do
      let(:response_body) do
        {
          "main" => {
            "temp" => 20,
            "temp_min" => 15,
            "temp_max" => 25,
            "humidity" => 50,
            "pressure" => 1013
          },
          "weather" => [
            { "description" => "clear sky" }
          ]
        }
      end

      before do
        stub_request(:get, "https://api.openweathermap.org/data/2.5/weather?appid=#{api_key}&lat=#{latitude}&lon=#{longitude}&units=metric")
          .to_return(status: 200, body: response_body.to_json, headers: {})
      end

      it 'returns weather data' do
        weather = WeatherService.call(latitude, longitude)
        expect(weather.temperature).to eq(20)
        expect(weather.temperature_min).to eq(15)
        expect(weather.temperature_max).to eq(25)
        expect(weather.humidity).to eq(50)
        expect(weather.pressure).to eq(1013)
        expect(weather.description).to eq("clear sky")
      end
    end

    context 'when the API request fails' do
      before do
        stub_request(:get, "https://api.openweathermap.org/data/2.5/weather?appid=#{api_key}&lat=#{latitude}&lon=#{longitude}&units=metric")
          .to_return(status: 500, body: "", headers: {})
      end

      it 'raises an IOError' do
        expect { WeatherService.call(latitude, longitude) }.to raise_error(IOError, /OpenWeather response body failed/)
      end
    end
  end
end
