# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/display'

class WordcountTest < Minitest::Test
  TARGET_TEXT = 'Nulla mi nulla, vehicula nec, ultrices a.'
  TARGET_FILENAME = ['test/fixtures/lorem_ipsum_5p.txt'].freeze
  MULTIPLE_TARGET_FILENAME = ['test/fixtures/lorem_ipsum_5p.txt', 'test/fixtures/lorem_ipsum_10p.txt'].freeze

  def test_wordcount_with_text
    expected = '       0       7      41'
    display_text = Wc::Display.new(TARGET_TEXT)
    assert_equal expected, display_text.show_wordcount
  end

  def test_wordcount_with_file
    expected = '      10     568    3870 test/fixtures/lorem_ipsum_5p.txt'
    display_file = Wc::Display.new(TARGET_FILENAME)
    assert_equal expected, display_file.show_wordcount
  end

  def test_wordcount_with_multiple_files
    expected = <<-TEXT.chomp
      10     568    3870 test/fixtures/lorem_ipsum_5p.txt
      19    1003    6778 test/fixtures/lorem_ipsum_10p.txt
      29    1571   10648 total
    TEXT
    display_files = Wc::Display.new(MULTIPLE_TARGET_FILENAME)
    assert_equal expected, display_files.show_wordcount
  end

  def test_linecount_with_text
    expected = '       0'
    display_text = Wc::Display.new(TARGET_TEXT)
    assert_equal expected, display_text.show_linecount
  end

  def test_linecount_with_file
    expected = '      10 test/fixtures/lorem_ipsum_5p.txt'
    display_file = Wc::Display.new(TARGET_FILENAME)
    assert_equal expected, display_file.show_linecount
  end

  def test_linecount_with_files
    expected = <<-TEXT.chomp
      10 test/fixtures/lorem_ipsum_5p.txt
      19 test/fixtures/lorem_ipsum_10p.txt
      29 total
    TEXT
    display_files = Wc::Display.new(MULTIPLE_TARGET_FILENAME)
    assert_equal expected, display_files.show_linecount
  end
end
