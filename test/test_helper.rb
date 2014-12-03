ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'active_resource'
require 'pp'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  VALID_BAN_LINK = 'http://forums.euw.leagueoflegends.com/board/showthread.php?t=123456'

  def current_user
    return ToolUser.default_user unless session[:tool_user_id]
    @current ||= ToolUser.find_by(id: session[:tool_user_id])
  end
end
