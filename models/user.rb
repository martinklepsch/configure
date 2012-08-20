require 'datamapper'

class User
  include DataMapper::Resource
  property :name, String, :unique => true, :key => true, :required => true
  property :clone_url, String, :required => true
end

DataMapper.auto_upgrade!
