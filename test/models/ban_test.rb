require 'test_helper'

class BanTest < ActiveSupport::TestCase
  test 'should create ban' do
    ban = Ban.create!(date: Time.now, duration: 1, user: users(:amshaegar))
    assert users(:amshaegar).bans.include?(ban)
  end

  test 'should fail to create ban without user' do
    assert_raises ActiveRecord::RecordInvalid do
      Ban.create!(date: Time.now, duration: 1)
    end
  end

  test 'should fail to create ban without duration' do
    assert_raises ActiveRecord::RecordInvalid do
      Ban.create!(date: Time.now, user: users(:amshaegar))
    end
  end

  test 'should fail to create ban without date' do
    assert_raises ActiveRecord::RecordInvalid do
      Ban.create!(duration: 1, user: users(:amshaegar))
    end
  end
end
