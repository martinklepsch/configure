require 'datamapper'

class User
  include DataMapper::Resource
  property :name, String, :unique => true, :key => true, :required => true
  property :clone_url, String, :required => true
  property :times_requested, Integer, :default => 0
  property :times_requested_public, Integer, :default => 0
end

DataMapper.auto_upgrade!
