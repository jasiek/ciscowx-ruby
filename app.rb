require './weather'

class App < Sinatra::Base
  get '/wx/:date' do
    city = request.env['GEOIP_CITY_NAME'].to_ascii
    country = request.env['GEOIP_COUNTRY_NAME'].to_ascii
    latitude = Float(request.env['GEOIP_LATITUDE'])
    longitude = Float(request.env['GEOIP_LONGITUDE'])
    date = params['date']

    builder do |xml|
      xml.CiscoIPPhoneText do |t|
        t.Title "#{city}, #{country} WX for #{date}"
        t.Text Weather.for(city, country, latitude, longitude, date)
      end
    end
  end
  
  get '/' do
    city = request.env['GEOIP_CITY_NAME'].to_ascii
    country = request.env['GEOIP_COUNTRY_NAME'].to_ascii
    
    builder do |xml|
      xml.CiscoIPPhoneMenu do |m|
        m.Title "Weather for #{city}, #{country}"
        m.MenuItem do |mi|
          mi.Name "#{city} today"
          mi.URL url("/wx/#{Date.today}")
        end
        m.MenuItem do |mi|
          mi.Name "#{city} tomorrow"
          mi.URL url("/wx/#{Date.today + 1}")
        end
        (2..5).each do |offset|
          date = Date.today + offset
          m.MenuItem do |mi|
            mi.Name "#{city} #{date}"
            mi.URL url("/wx/#{date}")
          end
        end
      end
    end
  end
end
