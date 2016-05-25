class App < Sinatra::Base
  get '/' do
    city = request.env['GEOIP_CITY_NAME']
    country = request.env['GEOIP_COUNTRY_NAME']
    
    builder do |xml|
      xml.CiscoIPPhoneMenu do |m|
        m.Title "Weather for (#{city}, #{country})"
        m.MenuItem do |mi|
          mi.Title "WX Krakow"
          mi.URL "/krakow"
        end
      end
    end
  end
end
