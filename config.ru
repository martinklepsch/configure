require 'rubygems'
require 'bundler/setup'

require './configure_app.rb'

run Sinatra::Application
