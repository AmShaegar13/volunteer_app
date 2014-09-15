require 'active_resource'

class Summoner < ActiveResource::Base
  @@resources = YAML.load_file('config/resources.yml')

  self.site = @@resources['riot_api']['base_url']
  self.collection_name ='summoner'
  self.include_format_in_path = false
  self.logger = Logger.new(STDERR) if Rails.env == 'development'

  @@api_key = @@resources['riot_api']['api_key']

  class << self
    ##
    # GET request to riot API.
    #
    def get(method_name, options = {})
      options[:api_key] = @@api_key
      HashWithIndifferentAccess.new(super(method_name, options))
    end

    def find_by_name(*names)
      names = names * ',' if names.is_a? Array
      get("by-name/#{names}")
    end
    alias_method :find_by_names, :find_by_name
  end
end