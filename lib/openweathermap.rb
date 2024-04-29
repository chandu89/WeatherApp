class Openweathermap
	attr_accessor :longitude, :latitude
	WEATHER_URL = '/data/2.5/weather'.freeze
	API_WEATHERMAP_URL = 'https://api.openweathermap.org'.freeze

	def initialize(longitude, latitude)
		@longitude = longitude
		@latitude = latitude
	end

	

	def get_weather
		request.get(WEATHER_URL, {
      appid: Rails.application.credentials.openweather_api_key,
      lat: latitude,
      lon: longitude,
      units: "metric",
    })
	end

	private

	def request
		@request ||= Faraday.new(API_WEATHERMAP_URL) do |f|
      f.request :json # encode req bodies as JSON and automatically set the Content-Type header
      f.request :retry # retry transient failures
      f.response :json # decode response bodies as JSON
    end 
	end
end