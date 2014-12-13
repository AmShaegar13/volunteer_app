require 'test_helper'

class UserTest < ActiveSupport::TestCase
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

  test 'should not set smurf-main association for different regions' do
    user = users(:amshaegar)
    smurf = users(:smurf_na)

    assert_nil smurf.main

    smurf.main = user
    ex = assert_raises ActiveRecord::RecordInvalid do
      smurf.save!
    end
    assert_equal 'Validation failed: Region must match main\'s region', ex.message

    smurf.reload
    assert_not_equal user, smurf.main
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
    assert_equal user, User.find_or_create_by!(id: user.id, region: user.region)
  end

  test 'should find user by name and region' do
    user = users(:amshaegar)

    summoner = mock('Summoner', id: user.summoner_id, name: user.name, summonerLevel: user.level)
    Summoner.expects(:find_by!).with(name: user.name, region: user.region).returns(summoner)

    assert_equal user, User.find_or_create_by!(name: user.name, region: user.region)
  end

  test 'should create user by name and region' do
    user = User.new summoner_id: 1337, name: 'DummyUser', level: 15, region: 'euw'

    summoner = mock('Summoner', id: user.summoner_id, name: user.name, summonerLevel: user.level)
    Summoner.expects(:find_by!).with(name: user.name, region: user.region).returns(summoner)

    assert_raise ActiveRecord::RecordNotFound do
      User.find_by! summoner_id: user.summoner_id
    end

    new = User.find_or_create_by!(name: user.name, region: user.region)

    assert_not_nil new
    assert_equal user.summoner_id, new.summoner_id
    assert_equal user.name, new.name
    assert_equal user.level, new.level
    assert_equal user.region, new.region
  end

  test 'should find user by name with region' do
    user = users(:amshaegar)

    summoner = mock('Summoner', id: user.summoner_id, name: user.name, summonerLevel: user.level)
    Summoner.expects(:find_by!).with(name: user.name, region: user.region).returns(summoner)

    assert_equal user, User.find_or_create_by!(name: '%s (%s)' % [user.name, user.region])
  end

  test 'should create user by name with region' do
    user = User.new summoner_id: 1337, name: 'DummyUser', level: 15, region: 'euw'

    summoner = mock('Summoner', id: user.summoner_id, name: user.name, summonerLevel: user.level)
    Summoner.expects(:find_by!).with(name: user.name, region: user.region).returns(summoner)

    assert_raise ActiveRecord::RecordNotFound do
      User.find_by! summoner_id: user.summoner_id
    end

    new = User.find_or_create_by!(name: '%s (%s)' % [user.name, user.region])

    assert_not_nil new
    assert_equal user.summoner_id, new.summoner_id
    assert_equal user.name, new.name
    assert_equal user.level, new.level
    assert_equal user.region, new.region
  end

  test 'should raise exception if summoner does not exist' do
    name = 'NoNeXiStEnT'
    region = 'euw'
    ex = VolunteerApp::SummonerNotFound
    ex_msg = 'Summoner does not exist.'

    Summoner.expects(:find_by!).with(name: name, region: region).raises(ex, ex_msg)

    assert_raise ex, ex_msg do
      User.find_or_create_by!(name: name, region: region)
    end
  end

  test 'should update user name' do
    user = users(:smurf_1)

    summoner = mock('Summoner', id: user.id, name: 'New Name', summonerLevel: 30)
    Summoner.expects(:find_by!).with(name: user.name, region: user.region).returns(summoner)

    user = User.find_or_create_by!(name: user.name, region: user.region)

    assert_equal 'New Name', user.name
    assert_equal 30, user.level
  end

  test 'should return user name for search term' do
    users = User.search('shae')
    assert_not_empty users
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

  test 'should find user with region by name' do
    user = users(:amshaegar)
    assert_equal user, User.find_by(name: '%s (%s)' % [user.name, user.region])
  end

  test 'should not find user with wrong region' do
    user = users(:amshaegar)
    assert_nil User.find_by(name: '%s (none)' % [user.region])
  end

  test 'should do exact match for array' do
    users = User.search('fÃ²Ã²bar')
    assert_equal 1, users.size
    assert_equal users(:broken_encoding), users.take
  end
end
