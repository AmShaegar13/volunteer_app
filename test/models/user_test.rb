require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'find by name should work' do
    assert_equal users(:amshaegar), User.find_by(name: 'AmShaegar')
  end

  test 'create user should work' do
    assert_nil User.find_by(name: 'Random User')

    User.create!(name: 'Random User')
    assert_not_nil User.find_by(name: 'Random User')
  end

  test 'smurf-main association should work' do
    user = User.find_by(name: 'AmShaegar')
    assert user.smurfs.include?(users(:smurf_1))
    assert_equal user, user.smurfs.sample.main
  end
end
