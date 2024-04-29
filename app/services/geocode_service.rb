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
