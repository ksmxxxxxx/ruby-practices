# frozen_string_literal: true

require 'minitest/autorun'
require './bowling.rb'

# Test
class BowlingScoreTest < Minitest::Test
  def test_sample1
    assert_equal 139, bowling_score('6390038273X9180X645')
  end

  def test_perfect_game
    assert_equal 300, bowling_score('XXXXXXXXXXXX')
  end

  def test_continuous_strikes
    assert_equal 107, bowling_score('0X150000XXX518104')
  end

  def test_strike_on_last_frame
    assert_equal 164, bowling_score('6390038273X9180XXXX')
  end
end
