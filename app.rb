require 'rubygems'
require 'sinatra'
require 'haml'
require 'uri'
require 'datamapper'
require 'pry'

class Configure < Sinatra::Base

  configure :development do
    DataMapper.setup( :default, "sqlite3://#{Dir.pwd}/configure-app.db" )
  end
  require_relative 'models/user'

  get '/' do
    haml :index
  end

  post '/setup_username' do
    clone_url = params[:github_clone_url]
    if clone_url.start_with?("git@github.com:") and clone_url.end_with?(".git")
      github_uri = clone_url.split(":").last
      username = github_uri.split("/").first
      repo = github_uri.split("/").last
      u = User.new(:name => username, :clone_url => repo)
      u.save
      haml :copy_field, :locals => {:user => u}, :layout => (request.xhr? ? false : :layout)
    else
      haml :invalid_url, :layout => (request.xhr? ? false : :layout)
    end
  end

  get '/users' do
    haml :users, :locals => {:users => User.all}
  end

  get '/:id' do
    user = User.first(:name => params[:id])
    binding.pry
    clone_url = "git@github.com:#{user.name}/#{user.clone_url}"
    erb :pinit, :locals => { :repo => clone_url }
  end
end
