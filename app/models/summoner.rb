require 'active_resource'

class Summoner < ActiveResource::Base
  @@resources = YAML.load_file('config/resources.yml')

  self.site = @@resources['riot_api']['base_url']
  self.collection_name ='summoner'
  self.include_format_in_path = false

  @@api_key = @@resources['riot_api']['api_key']

  ##
  # GET request to riot API.
  #
  def self.get(method_name, options = {})
    options[:api_key] = @@api_key
    HashWithIndifferentAccess.new(super(method_name, options))
  end
end