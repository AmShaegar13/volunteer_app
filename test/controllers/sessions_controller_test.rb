require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test 'should authenticate volunteer and create tool user' do
    tool_user = { id: 13, name: 'username', volunteer: true }
    auth = stub( 'success?' => true, user: tool_user )

    Authentication.expects(:new).with(params).returns(auth)

    get :verify, auth: params

    assert_redirected_to :root
    assert_equal tool_user[:id], session[:tool_user_id]
    assert_not_nil ToolUser.find(tool_user[:id])
  end

  test 'should authenticate volunteer and update tool user' do
    tool_user = { id: tool_users(:admin).id, name: 'username', volunteer: true }
    auth = stub( 'success?' => true, user: tool_user )

    Authentication.expects(:new).with(params).returns(auth)

    get :verify, auth: params

    assert_redirected_to :root
    assert_equal tool_user[:id], session[:tool_user_id]
    assert_equal tool_user[:name], ToolUser.find(tool_user[:id]).name
  end

  test 'should deny access to non volunteer' do
    tool_user = { id: 13, name: 'username', volunteer: false }
    auth = stub( 'success?' => true, user: tool_user )

    Authentication.expects(:new).with(params).returns(auth)

    get :verify, auth: params

    assert_redirected_to :root
    assert_not session.key? :tool_user_id
    assert_equal 'Permission denied.', flash[:error]
  end

  test 'should deny access with wrong password' do
    auth = stub( 'success?' => false, code: 401, error: 'Unauthorized')

    Authentication.expects(:new).with(params).returns(auth)

    get :verify, auth: params

    assert_redirected_to :root
    assert_not session.key? :tool_user_id
    assert_match /Unauthorized/, flash[:error]
    assert_match /401/, flash[:error]
  end

  test 'should logout' do
    session[:tool_user_id] = 1

    get :logout

    assert_not session.key?(:tool_user_id)
  end

  def params
    { 'login' => 'username', 'password' => 'secret' }
  end
  private :params
end
