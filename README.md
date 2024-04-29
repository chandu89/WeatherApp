# Weather Forecast App

A simple Rails application to display weather forecasts for given address including zip codes. It fetches weather data from a weather API and caches it for subsequent requests to improve performance.

## Features

- Accepts user input for an address including zip code
- Displays current temperature, minimum and maximum temperature, humidity, pressure, and description of weather
- Caches the forecast for 30 minutes for all subsequent requests by zip codes

## Usage

1. Enter a zip code in the provided form field.
2. Click "Get Weather Forecast" to retrieve the weather forecast for the entered zip code.
3. The application will display the current weather forecast, including temperature, humidity, pressure, and description.


## Installation

1. Clone the repository:
   ```bash
   1. git clone https://github.com/chandu89/WeatherApp.git
   2. cd WeatherApp
   3. bundle install 
   4. rails db:create
   5. bin/rails dev:cache # to Enable development cache
   6. rails s
   7. open http://127.0.0.1:3000

## Added 100% coverage for rspec
<img width="1427" alt="image" src="https://github.com/chandu89/WeatherApp/assets/5196979/65bace65-93e0-4ef6-bfaa-ad8bc03a76e7">


## Two service file which determines actual work
   1. **GeocodeService**: We need address from geocoder so added a service file to fetch 
   ```bash
   class GeocodeService 
        def self.call(address)
          response = Geocoder.search(address)
      
          raise IOError, "Geocoder error" unless response
      
          first_result = response.first
      
          raise IOError, "Geocoder is empty: #{response}" unless first_result
      
          data = first_result.data
      
          raise IOError, "Geocoder data error" unless data
      
          latitude = data.dig("lat").to_f  if data.dig("lat").present?
          longitude = data.dig("lon").to_f if data.dig("lon").present?
          country_code = data.dig("address", "country_code")
          postal_code = data.dig("address", "postcode")
      
          raise IOError, "Geocoder latitude is missing" unless latitude
          raise IOError, "Geocoder longitude is missing" unless longitude
          raise IOError, "Geocoder address is missing" unless country_code && postal_code
      
          Geocode.new(latitude, longitude, country_code, postal_code)
        rescue StandardError => e
          raise IOError, "Error fetching geocode data: #{e.message}"
        end
      
        Geocode = Struct.new(:latitude, :longitude, :country_code, :postal_code)
      end
   ```
   
   2. **WeatherService**: Will be responsible to fetch Weather data from `lib/Openweathermap` which is using `openweathermap.org` API. 
      To fetch API we need `openweather_api_key` for that we need to signup Openweathermap and you will receive API KEY which is encrypted in `rails credentials:edit` 

   ```bash
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
```

## DEMO VIDEO:
https://github.com/chandu89/WeatherApp/assets/5196979/6e45ad23-a704-4f14-b52e-90ff068dc653


