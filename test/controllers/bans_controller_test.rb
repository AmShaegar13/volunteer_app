require 'test_helper'

class BansControllerTest < ActionController::TestCase
  def setup
    session[:tool_user_id] = tool_users(:admin).id
  end

  test 'should create ban with id and set main' do
    user = users(:smurf_new)
    main = users(:humpel)
    bans = user.bans.count
    actions = current_user.actions.count

    User.expects(:find_or_create_by).with('id' => user.id.to_s).returns(user)
    User.expects(:find_or_create_by).with(name: main.name).returns(main)

    get :create, {
        ban: {
            duration: 14,
            reason: 'test',
            link: VALID_BAN_LINK,
            user: {
                id: user.id,
                main: main.name
            }
        }
    }

    assert_not flash.key?(:error.to_s), flash[:error]
    assert_redirected_to :root
    assert_equal bans+1, user.bans.count
    assert_equal actions+2, current_user.actions.count
    assert_equal main, user.main
  end

  test 'should create ban with name' do
    user = users(:amshaegar)
    bans = user.bans.count
    actions = current_user.actions.count

    User.expects(:find_or_create_by).with('name' => user.name).returns(user)

    ban_user_by_name(user.name)

    assert_not flash.key?(:error.to_s), flash[:error]
    assert_redirected_to :root
    assert_equal bans+1, user.bans.count
    assert_equal actions+1, current_user.actions.count
  end

  test 'should create ban with name of new user' do
    user = User.new id: 1337, name: 'DummyUser'
    actions = current_user.actions.count

    assert_raise ActiveRecord::RecordNotFound do
      User.find 1337
    end

    User.expects(:find_or_create_by).with('name' => user.name).returns(user)

    ban_user_by_name(user.name)

    assert_not flash.key?(:error.to_s), flash[:error]
    assert_redirected_to :root
    assert_equal 1, user.bans.count
    assert_equal actions+1, current_user.actions.count
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

  # TODO find a better way than code duplication
  def current_user
    return nil unless session.key? :tool_user_id
    ToolUser.current ||= ToolUser.find_by(id: session[:tool_user_id])
  end
  private :current_user
end
