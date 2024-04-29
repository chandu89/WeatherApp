require 'rails_helper'

RSpec.describe WeatherForecastsController, type: :controller do
  describe "GET #index" do
    it "returns HTTP success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "private methods" do
    describe "#set_address" do
      it "assigns the address parameter to @address" do
        controller.params[:address] = 'berlin, 12345'
        controller.send(:set_address)
        expect(assigns(:address)).to eq('berlin, 12345')
      end
    end
  end

  describe "GET #forecast" do
    context "with valid address" do
      let(:address) { "New York, NY" }
      let(:geocode) { Struct.new(:latitude, :longitude, :country_code, :postal_code).new(40.7128, -74.0060, "US", "10001") }
      let(:weather_forecast) do
        OpenStruct.new(
          temperature: 20,
          temperature_min: 15,
          temperature_max: 25,
          humidity: 50,
          pressure: 1015,
          description: "Sunny"
        )
      end

      before do
        allow(GeocodeService).to receive(:call).with(address).and_return(geocode)
        allow(WeatherService).to receive(:call).with(geocode.latitude, geocode.longitude).and_return(weather_forecast)
        get :forecast, params: { address: address }
      end

      it "assigns @weather_forecast" do
        expect(assigns(:weather_forecast)).to eq(weather_forecast)
      end

      it "renders the forecast template" do
        expect(response).to render_template(:forecast)
      end
    end

    context "with invalid address" do
      let(:address) { nil }

      before do
        get :forecast, params: { address: address }
      end

      it "does not assign @weather_forecast" do
        expect(assigns(:weather_forecast)).to be_nil
      end

      it "sets flash alert message" do
        expect(flash[:alert]).to be_present
      end
    end
  end
end

