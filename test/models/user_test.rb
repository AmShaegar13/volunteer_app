require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should find by name' do
    assert_equal users(:amshaegar), User.find_by(name: 'AmShaegar')
  end

  test 'should create user' do
    assert_nil User.find_by(name: 'Random User')

    User.create!(name: 'Random User')
    assert_not_nil User.find_by(name: 'Random User')
  end

  test 'should test smurf-main association' do
    user = User.find_by(name: 'AmShaegar')
    assert user.smurfs.include?(users(:smurf_1))
    assert_equal user, user.smurfs.sample.main
  end

  test 'should fail to create user without name' do
    assert_raises ActiveRecord::RecordInvalid do
      User.create!
    end
  end
end
