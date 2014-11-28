require 'test_helper'

class BanTest < ActiveSupport::TestCase
  test 'should return bans ordered by end' do
    bans = Ban.ordered_by_end

    assert_not_equal 0, bans.size
    assert_equal Ban, bans.first.class

    dates = bans.map(&:ends)

    dates.inject do |memo, element|
      # check order
      assert memo >= element
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

  test 'ban should have creator' do
    creator = bans(:one_day).creator
    assert_equal tool_users(:admin), creator
  end
end
