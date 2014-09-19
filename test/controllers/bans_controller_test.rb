require 'test_helper'

class BansControllerTest < ActionController::TestCase
  test 'should create ban with id' do
    user = users(:amshaegar)
    bans = user.bans.count

    Summoner.expects(:find_by_name).never

    get :create, {
        ban: {
            duration: 14,
            reason: 'test',
            link: VALID_BAN_LINK,
            user: {
                id: user.id
            }
        }
    }

    assert_not flash.key? 'error'
    assert_redirected_to :root
    assert_equal bans+1, user.bans.count
  end

  test 'should create ban with name' do
    user = users(:amshaegar)
    bans = user.bans.count

    summoner = Summoner.new(id: user.id, name: user.name)
    Summoner.expects(:find_by_name).with(user.name).returns(summoner)

    ban_user_by_name(user.name)

    assert_not flash.key? 'error'
    assert_redirected_to :root
    assert_equal bans+1, user.bans.count
  end

  test 'should create ban with name of new user' do
    user = User.new id: 1337, name: 'DummyUser'

    summoner = Summoner.new(id: user.id, name: user.name)
    Summoner.expects(:find_by_name).with(user.name).returns(summoner)

    ban_user_by_name(user.name)

    assert_not flash.key? 'error'
    assert_redirected_to :root
    assert_equal 1, user.bans.count
    assert_not_nil User.find 1337
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
