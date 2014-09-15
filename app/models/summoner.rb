require 'active_resource'

class Summoner < ActiveResource::Base
  self.site = 'https://euw.api.pvp.net/api/lol/euw/v1.4/'
  self.collection_name ='summoner'
  self.include_format_in_path = false

  self.logger = Logger.new(STDERR)

  ##
  # GET request to riot API.
  #
  def self.get(method_name, options = {})
    options[:api_key] = '' # TODO find a way to load api_key from external source
    super(method_name, options)
  end
end