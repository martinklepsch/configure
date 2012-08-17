require 'rubygems'
require 'sinatra'
require 'haml'
require 'uri'
# require 'mongo'


class Configure < Sinatra::Base
  get '/' do
    haml :index
  end

  post '/setup_username' do
    github_uri = URI(params[:github_clone_url])
    haml :copy_field, :locals => {:username => github_uri.path}, :layout => (request.xhr? ? false : :layout)
  end

  get '/:id' do
    send_file 'pinit.sh'
  end
end
