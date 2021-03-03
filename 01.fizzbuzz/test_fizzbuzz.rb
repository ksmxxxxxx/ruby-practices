def fizzbuzz(a, z)
  num = []
  (a..z).each do |x|
    if x % 15 == 0
      num << 'fizzbuzz'
    elsif x % 5 == 0
      num << 'buzz'
    elsif x % 3 == 0
      num << 'fizz'
    else
      num << x
    end
  end
  p num
end

fizzbuzz(1, 100)

require 'minitest/autorun'

class FizzBuzzTest < Minitest::Test
  def test_fizz
    num = fizzbuzz(1, 10)
    assert_equal num.length, 10
    val = 1
    (0..9).each do |x|
      if x == 2
        assert_equal num[x], 'fizz'
      elsif x == 5
        assert_equal num[x], 'fizz'
      elsif x == 8
        assert_equal num[x], 'fizz'
      end
      val += 1
    end
  end

  def test_buzz
    num = fizzbuzz(1, 10)
    assert_equal num.length, 10
    val = 1
    (0..9).each do |x|
      if x == 4
        assert_equal num[x], 'buzz'
      elsif x == 9
        assert_equal num[x], 'buzz'
      end
      val += 1
    end
  end

  def test_fizzbuzz
    num = fizzbuzz(1, 30)
    assert_equal num.length, 30
    val = 1
    (0..29).each do |x|
      if x == 14
        assert_equal num[x], 'fizzbuzz'
      elsif x == 29
        assert_equal num[x], 'fizzbuzz'
      end
      val += 1
    end
  end
end
