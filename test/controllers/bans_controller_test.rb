require 'test_helper'

class BansControllerTest < ActionController::TestCase
  test 'should create ban with id' do
    get :create, {
        ban: {
            duration: 14,
            reason: 'test',
            link: VALID_BAN_LINK,
            user: {
                id: users(:amshaegar).id
            }
        }
    }

    assert_not flash.key? 'error'
    assert_redirected_to :root
  end

  test 'should create ban with name' do
    user = users(:amshaegar)
    bans = user.bans.count

    get :create, {
        ban: {
            duration: 14,
            reason: 'test',
            link: VALID_BAN_LINK,
            user: {
                name: user.name
            }
        }
    }

    assert_not flash.key? 'error'
    assert_redirected_to :root
    assert_equal bans+1, user.bans.count
  end
end
