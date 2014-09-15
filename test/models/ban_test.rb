require 'test_helper'

class BanTest < ActiveSupport::TestCase
  test 'should create ban even without date' do
    pp ban = Ban.create!(
        duration: 1,
        user: users(:amshaegar),
        reason: 'flame',
        link: 'http://forums.euw.leagueoflegends.com/board/showthread.php?t=123456'
    )
    assert users(:amshaegar).bans.include?(ban)
  end

  test 'should fail to create ban without user' do
    assert_raises ActiveRecord::RecordInvalid do
      Ban.create!(
          duration: 1,
          reason: 'flame',
          link: 'http://forums.euw.leagueoflegends.com/board/showthread.php?t=123456'
      )
    end
  end

  test 'should fail to create ban without duration' do
    assert_raises ActiveRecord::RecordInvalid do
      Ban.create!(
          user: users(:amshaegar),
          reason: 'flame',
          link: 'http://forums.euw.leagueoflegends.com/board/showthread.php?t=123456'
      )
    end
  end

  test 'should fail to create ban without reason' do
    assert_raises ActiveRecord::RecordInvalid do
      Ban.create!(
          duration: 1,
          user: users(:amshaegar),
          link: 'http://forums.euw.leagueoflegends.com/board/showthread.php?t=123456'
      )
    end
  end

  test 'should fail to create ban without link' do
    assert_raises ActiveRecord::RecordInvalid do
      Ban.create!(
          duration: 1,
          user: users(:amshaegar),
          reason: 'flame',
      )
    end
  end
end
