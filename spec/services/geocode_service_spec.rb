require 'rails_helper'

RSpec.describe GeocodeService do
  describe '.call' do
    context 'with valid address' do
      let(:address) { 'Valid Address' }
      let(:response_data) do
        {
          'lat' => '10.1234',
          'lon' => '20.5678',
          'address' => {
            'country_code' => 'US',
            'postcode' => '12345'
          }
        }
      end

      before do
        allow(Geocoder).to receive(:search).with(address).and_return([double(data: response_data)])
      end

      it 'returns a Geocode object' do
        geocode = GeocodeService.call(address)
        expect(geocode).to be_a(GeocodeService::Geocode)
      end

      it 'correctly extracts latitude, longitude, country code, and postal code' do
        geocode = GeocodeService.call(address)
        expect(geocode.latitude).to eq(10.1234)
        expect(geocode.longitude).to eq(20.5678)
        expect(geocode.country_code).to eq('US')
        expect(geocode.postal_code).to eq('12345')
      end
    end

    context 'with invalid address' do
      let(:address) { 'Invalid Address' }

      before do
        allow(Geocoder).to receive(:search).with(address).and_return(nil)
      end

      it 'raises an IOError' do
        expect { GeocodeService.call(address) }.to raise_error(IOError, /Geocoder error/)
      end
    end

    context 'with empty response from geocoder' do
      let(:address) { 'Empty Response Address' }

      before do
        allow(Geocoder).to receive(:search).with(address).and_return([])
      end

      it 'raises an IOError' do
        expect { GeocodeService.call(address) }.to raise_error(IOError, 'Error fetching geocode data: Geocoder is empty: []')
      end
    end

    context 'with missing latitude in response data' do
      let(:address) { 'Missing Latitude Address' }

      before do
        allow(Geocoder).to receive(:search).with(address).and_return([double(data: { 'lon' => '20.5678', 'address' => { 'country_code' => 'US', 'postcode' => '12345' } })])
      end

      it 'raises an IOError' do
        expect { GeocodeService.call(address) }.to raise_error(IOError, /Geocoder latitude is missing/)
      end
    end

    context 'when geocoder data is malformed' do
      let(:address) { 'Malformed Data Address' }

      before do
        allow(Geocoder).to receive(:search).with(address).and_return([double(data: { 'invalid_key' => 'value' })])
      end

      it 'raises an IOError' do
        expect { GeocodeService.call(address) }.to raise_error(IOError, /Error fetching geocode data/)
      end
    end

    context 'when geocoder data is empty or nil' do
      let(:address) { 'Nil Data Address' }

      before do
        allow(Geocoder).to receive(:search).with(address).and_return(nil)
      end

      it 'raises an IOError' do
        expect { GeocodeService.call(address) }.to raise_error(IOError, /Geocoder error/)
      end
    end

  end
end
