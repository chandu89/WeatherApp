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
   git clone https://github.com/chandu89/WeatherApp.git
