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
end

