class App < Sinatra::Base
  get '/wx/:date' do
    city = request.env['GEOIP_CITY_NAME']
    country = request.env['GEOIP_COUNTRY_NAME']
    date = params['date']
    
    builder do |xml|
      xml.CiscoIPPhoneText do |t|
        t.Title "Weather for #{city}, #{country} for #{date}"
        t.Text "Weather forecast goes here"
      end
    end
  end
  
  get '/' do
    city = request.env['GEOIP_CITY_NAME']
    country = request.env['GEOIP_COUNTRY_NAME']
    
    builder do |xml|
      xml.CiscoIPPhoneMenu do |m|
        m.Title "Weather for #{city}, #{country}"
        m.MenuItem do |mi|
          mi.Title "Krakow today"
          mi.URL url("/wx/#{Date.today}")
        end
        m.MenuItem do |mi|
          mi.Title "Krakow tomorrow"
          mi.URL url("/wx/#{Date.today + 1}")
        end
        (2..5).each do |offset|
          date = Date.today + offset
          m.MenuItem do |mi|
            mi.Title "Krakow #{date}"
            mi.URL url("/wx/#{date}")
          end
        end
      end
    end
  end
end
