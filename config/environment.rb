# Load the Rails application.
require File.expand_path('../application', __FILE__)

require 'resources'
Resources.data = YAML.load_file('config/resources.yml')

# Initialize the Rails application.
Rails.application.initialize!

require 'pp' if Rails.env == 'development'

Yap.configure do |defaults|
  defaults.per_page = 25
  defaults.sort = :created_at
  defaults.direction = :desc
end

LINK_REGEXP = /((https?|ftp)\:\/\/)?([a-z0-9+!*(),;?&=\$_.-]+(\:[a-z0-9+!*(),;?&=\$_.-]+)?@)?([a-z0-9\-.]*)\.([a-z]{2,3})(\:[0-9]{2,5})?(\/([a-z0-9+\$_\-]\.?)+)*\/?(\?[a-z+&\$_.\-][a-z0-9;:@&%=+\/\$_.\-]*)?(#[a-z_.\-][a-z0-9+\$_.\-]*)?/
