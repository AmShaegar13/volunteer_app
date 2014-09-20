# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

require 'pp'

require 'resources'
Resources.data = YAML.load_file('config/resources.yml')

require 'authentication'
