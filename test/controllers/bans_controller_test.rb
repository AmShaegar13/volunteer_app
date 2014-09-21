require 'test_helper'

class BansControllerTest < ActionController::TestCase
  def setup
    session[:tool_user_id] = tool_users(:admin).id
  end

  test 'should create ban with name' do
    user = users(:amshaegar)
    bans = user.bans.count

    User.expects(:find_or_create).with(user.name).returns(user)

    ban_user_by_name(user.name)

    assert_not flash.key? 'error'
    assert_redirected_to :root
    assert_equal bans+1, user.bans.count
  end

  test 'should create ban with name of new user' do
    user = User.new id: 1337, name: 'DummyUser'

    assert_raise ActiveRecord::RecordNotFound do
      User.find 1337
    end

    User.expects(:find_or_create).with(user.name).returns(user)

    ban_user_by_name(user.name)

    assert_not flash.key? 'error'
    assert_redirected_to :root
    assert_equal 1, user.bans.count
  end

  def ban_user_by_name(name)
    get :create, {
        ban: {
            duration: 14,
            reason: 'test',
            link: VALID_BAN_LINK,
            user: {
                name: name
            }
        }
    }
  end
  private :ban_user_by_name
end
