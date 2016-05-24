class App < Sinatra::Base
  get '/' do
    city = request.env['X_GEOIP_CITY_NAME']
    country = request.env['X_GEOIP_COUNTRY']
    
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
