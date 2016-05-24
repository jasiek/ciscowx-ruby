require 'rubygems'
require 'bundler'
Bundler.require
require './app'

use Rack::GeoIPCity, db: 'vendor/GeoIPCity.dat'
run App.new
