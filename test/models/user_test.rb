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

  test 'should have smurf-main association' do
    user = users(:amshaegar)
    assert user.smurfs.include?(users(:smurf_1))
    assert_equal user, user.smurfs.sample.main
  end

  test 'should set smurf-main association as main' do
    user = users(:humpel)
    smurf = users(:smurf_new)

    assert_equal 0, user.smurfs.size
    assert_nil smurf.main

    user.smurfs << smurf

    assert_equal 1, user.smurfs.size
    assert_equal user, smurf.main
  end

  test 'should set smurf-main association as smurf' do
    user = users(:humpel)
    smurf = users(:smurf_new)

    assert_equal 0, user.smurfs.size
    assert_nil smurf.main

    smurf.main = user
    smurf.save!

    user.reload

    assert_equal 1, user.smurfs.size
    assert_equal user, smurf.main
  end

  test 'should fail to create user without name' do
    ex = assert_raises ActiveRecord::RecordInvalid do
      User.create!
    end
    assert_match /Name can't be blank/, ex.message
  end
end
