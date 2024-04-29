class WeatherService
  def self.call(latitude, longitude)
    response = Openweathermap.new(longitude, latitude).get_weather

    raise IOError.new("OpenWeather response body failed") if response.body.nil?

    main_data = response.body["main"]
    weather_data = response.body["weather"].first

    raise IOError.new("OpenWeather main section is missing") if main_data.nil?
    raise IOError.new("OpenWeather weather section is missing") if weather_data.nil?

    weather = OpenStruct.new(
      temperature: main_data["temp"],
      temperature_min: main_data["temp_min"],
      temperature_max: main_data["temp_max"],
      humidity: main_data["humidity"],
      pressure: main_data["pressure"],
      description: weather_data["description"]
    )

    weather
  end
    
end
