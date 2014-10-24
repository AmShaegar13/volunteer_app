require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should find by name' do
    assert_equal users(:amshaegar), User.find_by(name: 'AmShaegar')
  end

  test 'should create user' do
    assert_nil User.find_by name: 'Random User'

    User.create! id: 42, name: 'Random User', level: 30
    assert_not_nil User.find 42
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

  test 'should destroy bans of user' do
    user = users(:amshaegar)
    bans = user.bans

    assert_not_equal 0, bans.count

    user.destroy

    assert_equal 0, bans.count
  end

  test 'should nullify main' do
    user = users(:amshaegar)
    smurfs = user.smurfs
    smurf = smurfs.first

    assert_not_equal 0, smurfs.count
    assert_not_nil smurf.main

    user.destroy
    smurf.reload

    assert_equal 0, smurfs.count
    assert_nil smurf.main
  end

  test 'should find user by id' do
    user = users(:amshaegar)
    assert_equal user, User.find_or_create_by(id: user.id)
  end

  test 'should find user by name' do
    user = users(:amshaegar)

    summoner = Summoner.new(id: user.id, name: user.name, summonerLevel: user.level)
    Summoner.expects(:find_by_name).with(user.name).returns(summoner)

    assert_equal user, User.find_or_create_by(name: user.name)
  end

  test 'should create user by name' do
    user = User.new id: 1337, name: 'DummyUser', level: 15

    summoner = Summoner.new(id: user.id, name: user.name, summonerLevel: user.level)
    Summoner.expects(:find_by_name).with(user.name).returns(summoner)

    assert_raise ActiveRecord::RecordNotFound do
      User.find 1337
    end

    assert_equal user, User.find_or_create_by(name: user.name)
  end

  test 'should update user name' do
    user = users(:smurf_1)

    summoner = Summoner.new(id: user.id, name: 'New Name', summonerLevel: 30)
    Summoner.expects(:find_by_name).with(user.name).returns(summoner)

    user = User.find_or_create_by(name: user.name)

    assert_equal 'New Name', user.name
    assert_equal 30, user.level
  end

  test 'should return user name for search term' do
    users = User.search('shae')
    users.each do |user|
      assert_match /shae/, user.name.downcase
    end
  end

  test 'should not raise exception' do
    assert_nothing_raised do
      users = User.search('NoNeXiStEnT')
      assert_equal 0, users.size
    end
  end
end
