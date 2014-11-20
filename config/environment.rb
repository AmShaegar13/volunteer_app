# Load the Rails application.
require File.expand_path('../application', __FILE__)

require 'resources'
Resources.data = YAML.load_file('config/resources.yml')

# Initialize the Rails application.
Rails.application.initialize!

require 'pp'
