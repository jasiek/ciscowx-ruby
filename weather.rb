require 'json'

ForecastIO.api_key = ENV['FORECASTIO_KEY']

class Weather
  TTL = 24 * 3600
  
  def initialize(url=ENV["REDISCLOUD_URL"], city:, country:, latitude:, longitude:)
    @redis = Redis.new(url: url)
    @latitude = latitude
    @longitude = longitude
    @city = city
    @country = country
  end
  
  def self.for(city, country, latitude, longitude, date)
    self.new(city: city, country: country, latitude: latitude, longitude: longitude).textual(date)
  end

  def textual(date)
    unless for_date = content_for_date(retrieve_content, date)
      return 'No forecast available'
    end

    output = []
    output << for_date.summary
    output << "#{Integer(100 * for_date.precipProbability)} pct chance of rain"
    output << "Temperatures: #{for_date.temperatureMin}-#{for_date.temperatureMax}C"
    output << "Humidity: #{Integer(100 * for_date.humidity)}"
    output.join("\n")
  end

  def key
    [@city, @country].join(",")
  end

  def retrieve_content
    if content = @redis.get(key)
      Hashie::Mash.new(JSON.parse(content))
    else
      fetch_and_store_content
    end
  end
  
  def fetch_and_store_content
    forecast = ForecastIO.forecast(@latitude, @longitude, params: {exclude: 'minutely,hourly', units: 'si'})
    @redis.setex(key, TTL, forecast.to_json)
    forecast
  end

  def content_for_date(content, date)
    content.daily.data.find do |data|
      Time.at(data.time).to_date == Date.parse(date)
    end
  end
end
