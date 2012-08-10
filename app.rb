require 'rubygems'
require 'sinatra'
# require 'haml'
# require 'uri'
# require 'mongo'

get '/' do
  send_file 'pinit.sh'
end
