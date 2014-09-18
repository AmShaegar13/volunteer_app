require 'test_helper'

class BanTest < ActiveSupport::TestCase
  test 'should create ban with link to thread' do
    ban = Ban.create!(
        duration: 1,
        user: users(:amshaegar),
        reason: 'flame',
        link: 'http://forums.euw.leagueoflegends.com/board/showthread.php?t=123456'
    )
    assert users(:amshaegar).bans.include?(ban)
  end

  test 'should create ban with link to post and stuff' do
    ban = Ban.create!(
        duration: 1,
        user: users(:amshaegar),
        reason: 'flame',
        link: 'http://forums.euw.leagueoflegends.com/board/showthread.php?p=123456&highlight=search_keyword#post123456'
    )
    assert users(:amshaegar).bans.include?(ban)
  end

  test 'should fail to create ban without user' do
    ex = assert_raises ActiveRecord::RecordInvalid do
      Ban.create!(
          duration: 1,
          reason: 'flame',
          link: 'http://forums.euw.leagueoflegends.com/board/showthread.php?t=123456'
      )
    end
    assert_match /User can't be blank/, ex.message
  end

  test 'should fail to create ban without duration' do
    ex = assert_raises ActiveRecord::RecordInvalid do
      Ban.create!(
          user: users(:amshaegar),
          reason: 'flame',
          link: 'http://forums.euw.leagueoflegends.com/board/showthread.php?t=123456'
      )
    end
    assert_match /Duration can't be blank/, ex.message
  end

  test 'should fail to create ban with invalid duration' do
    ex = assert_raises ActiveRecord::RecordInvalid do
      Ban.create!(
          duration: 13,
          user: users(:amshaegar),
          reason: 'flame',
          link: 'http://forums.euw.leagueoflegends.com/board/showthread.php?t=123456'
      )
    end
    assert_match /Duration is not included in the list/, ex.message
  end

  test 'should fail to create ban without reason' do
    ex = assert_raises ActiveRecord::RecordInvalid do
      Ban.create!(
          duration: 1,
          user: users(:amshaegar),
          link: 'http://forums.euw.leagueoflegends.com/board/showthread.php?t=123456'
      )
    end
    assert_match /Reason can't be blank/, ex.message
  end

  test 'should fail to create ban without link' do
    ex = assert_raises ActiveRecord::RecordInvalid do
      Ban.create!(
          duration: 1,
          user: users(:amshaegar),
          reason: 'flame'
      )
    end
    assert_match /Link can't be blank/, ex.message
  end

  test 'should fail to create ban with invalid link' do
    ex = assert_raises ActiveRecord::RecordInvalid do
      Ban.create!(
          duration: 1,
          user: users(:amshaegar),
          reason: 'flame',
          link: 'http://google.de'
      )
    end
    assert_match /Link is invalid/, ex.message
  end

  test 'should return bans ordered by end' do
    bans = Ban.ordered_by_end

    assert_not_equal 0, bans.size
    assert_equal Ban, bans.first.class

    dates = bans.map(&:ends)

    dates.inject do |memo, element|
      # check order
      assert memo > element
      element
    end
  end

  test 'ban should be permanent' do
    assert bans(:permanent).permanent?
    assert_not bans(:seven_days_ongoing).permanent?
    assert_not bans(:three_days).permanent?
    assert_not bans(:five_days).permanent?
  end

  test 'ban should be active' do
    assert bans(:permanent).active?
    assert bans(:seven_days_ongoing).active?
    assert_not bans(:three_days).active?
    assert_not bans(:five_days).active?
  end
end
