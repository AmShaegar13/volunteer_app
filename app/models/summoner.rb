require 'active_resource'

class Summoner < ActiveResource::Base
  @@resources = YAML.load_file('config/resources.yml')
  @@api_key = @@resources['riot_api']['api_key']

  self.site = @@resources['riot_api']['base_url']
  self.collection_name ='summoner'
  self.include_format_in_path = false
  self.logger = Logger.new(STDERR) if Rails.env == 'development'

  class << self
    ##
    # GET request to riot API.
    #
    def get(method_name, options = {})
      options[:api_key] = @@api_key
      HashWithIndifferentAccess.new(super(method_name, options))
    end

    def find_by_name(name)
      names = [name]
      names << fix_encoding(name, Encoding::ISO8859_1) rescue nil
      names << fix_encoding(name, Encoding::ISO8859_2) rescue nil
      names << fix_encoding(name, Encoding::WINDOWS_1252) rescue nil
      names = URI::encode(names * ',')
      new(get("by-name/#{names}"))
    rescue ActiveResource::ResourceNotFound
      nil
    end
    alias_method :find_by_names, :find_by_name

    def fix_encoding(str, enc)
      str.encode(enc).force_encoding(Encoding::UTF_8)
    end
    private :fix_encoding
  end
end