require 'rubygems'
require 'bundler'
Bundler.require
require './app'

use Rack::GeoIPCity, db: 'GeoLiteCity.dat'
run App.new
