require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    session[:tool_user_id] = tool_users(:admin).id
  end

  test 'should return json with user names' do
    @request.accept = 'application/json'
    get :search, search_query: 'shae'
    assert_response :success
    json = JSON @response.body
    assert_not_equal 0, json.size
    json.each do |name|
      assert_not_nil User.find_by_name name
    end
  end

  test 'should return empty json' do
    @request.accept = 'application/json'
    get :search, search_query: 'NoNeXiStEnT'
    assert_response :success
    json = JSON @response.body
    assert_equal 0, json.size
  end
end
