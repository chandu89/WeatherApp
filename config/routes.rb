Rails.application.routes.draw do
  root 'weather_forecasts#index'
  get '/forecast', to: 'weather_forecasts#forecast', as: 'forecast'
end
