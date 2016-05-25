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
          mi.URL "/wx/#{Date.today}"
        end
        m.MenuItem do |mi|
          mi.Title "Krakow tomorrow"
          mi.URL "/wx/#{Date.today + 1}"
        end
        (Date.today + 2)..(Date.today + 5).each do |date|
          m.MenuItem do |mi|
            mi.Title "Krakow #{date}"
            mi.URL "/wx/#{date}"
          end
        end
      end
    end
  end
end
