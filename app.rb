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
    clone_url = params[:github_clone_url]
    if clone_url.start_with?("git@github.com:") and clone_url.end_with?(".git")
      github_uri = clone_url.split(":").last
      username = github_uri.split("/").first
      repo = github_uri.split("/").last
      haml :copy_field, :locals => {:username => username}, :layout => (request.xhr? ? false : :layout)
    else
      haml :not_private_clone_url, :layout => (request.xhr? ? false : :layout)
    end
  end

  get '/:id' do
    send_file 'pinit.sh'
  end
end
