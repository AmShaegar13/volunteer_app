require 'active_resource'

class Summoner < ActiveResource::Base
  @@api_key = Resources.data['riot_api']['api_key']

  self.site = Resources.data['riot_api']['base_url']
  self.collection_name ='summoner'
  self.include_format_in_path = false
  self.logger = Logger.new(STDERR) if Rails.env == 'development'

  class << self
    def element_path(id, prefix_options = {}, query_options = {})
      pp id
      super(id, prefix_options, query_options.merge({ api_key: @@api_key }))
    end

    def collection_path(prefix_options = {}, query_options = {})
      super(prefix_options, query_options.merge({ api_key: @@api_key }))
    end

    def find_by_name(name)
      names = [URI::encode(name)]
      names << fix_encoding(name, Encoding::ISO8859_1) rescue nil
      names << fix_encoding(name, Encoding::ISO8859_2) rescue nil
      names << fix_encoding(name, Encoding::WINDOWS_1252) rescue nil
      names = names.uniq * ','
      find "by-name/#{names}"
    rescue ActiveResource::ResourceNotFound
      nil
    end

    def fix_encoding(str, enc)
      URI::encode(str.encode(enc).force_encoding(Encoding::UTF_8))
    end
    private :fix_encoding
  end
end