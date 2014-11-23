require 'active_resource'

class Summoner < ActiveResource::Base
  self.collection_name = 'summoner'
  self.include_format_in_path = false
  self.logger = Logger.new(STDERR) if Rails.env == 'development'

  class << self
    def element_path(id, prefix_options = {}, query_options = {})
      super(id, prefix_options.merge({ region: @@region }), query_options.merge({ api_key: Rails.application.secrets.riot_api }))
    end

    def collection_path(prefix_options = {}, query_options = {})
      super(prefix_options.merge({ region: @@region }), query_options.merge({ api_key: Rails.application.secrets.riot_api }))
    end

    def find_by!(params = {})
      if params.keys.sort == [:name, :region]
        self.site = Resources.data['riot_api']['base_url'][params[:region]]
        @@region = params[:region]
        find_by_name params[:name]
      else
        super params
      end
    end

    def find_by_name(name)
      names = [name]
      names << fix_encoding(name, Encoding::ISO8859_1) rescue nil
      names << fix_encoding(name, Encoding::ISO8859_2) rescue nil
      names << fix_encoding(name, Encoding::WINDOWS_1252) rescue nil
      names = names.uniq * ','
      find "by-name/#{names}"
    end
    private :find_by_name

    def fix_encoding(str, enc)
      str = str.encode(enc).force_encoding(Encoding::UTF_8)
      raise ArgumentError, 'Invalid encoding' unless str.valid_encoding?
      str
    end
    private :fix_encoding
  end
end