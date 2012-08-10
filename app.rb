require 'rubygems'
require 'sinatra'
# require 'haml'
# require 'uri'
# require 'mongo'

get '/' do
  redirect '/pinit.sh'
end

get '/pinit.sh' do
  send_file 'pinit.sh'
end
