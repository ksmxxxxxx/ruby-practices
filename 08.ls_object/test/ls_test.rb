# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/display'

class LsTest < Minitest::Test
  TARGET_PATH = 'test/fixtures'
  TARGET_PATH_NO_SPRIT = 'test'

  def test_ls_short_format_sprit_into_column
    skip '環境によって表示が変わるので、lsコマンドの実行結果をexpectedとしてテストしたかったが、やり方が見つけられなかったのでこのテストはSkipします'
    expected = <<~TEXT.chomp
      dir_foobar          dummy_file_002.txt  dummy_file_004.txt  lorem_ipsum_10p.txt lorem_ipsum_2p.txt  symlink_file.txt
      dummy_file_001.txt  dummy_file_003.txt  dummy_file_005.txt  lorem_ipsum_1p.txt  lorem_ipsum_5p.txt
    TEXT
    display = Display.new(TARGET_PATH)
    display.list_without_dotfile
    assert_equal expected, display.short_format_split_into_columns
  end

  def test_ls_short_format
    expected = <<~TEXT.chomp
      fixtures   ls_test.rb
    TEXT
    display = Display.new(TARGET_PATH_NO_SPRIT)
    display.list_without_dotfile
    assert_equal expected, display.short_format
  end

  def test_ls_display_dotfiles
    skip '環境によって表示が変わるので、lsコマンドの実行結果をexpectedとしてテストしたかったが、やり方が見つけられなかったのでこのテストはSkipします'
    expected = <<~TEXT.chomp
      .                   dir_foobar          dummy_file_002.txt  dummy_file_004.txt  lorem_ipsum_10p.txt lorem_ipsum_2p.txt  symlink_file.txt
      ..                  dummy_file_001.txt  dummy_file_003.txt  dummy_file_005.txt  lorem_ipsum_1p.txt  lorem_ipsum_5p.txt
    TEXT
    display = Display.new(TARGET_PATH)
    display.list_contain_dotfile
    assert_equal expected, display.short_format_split_into_columns
  end

  def test_ls_reverse
    skip '環境によって表示が変わるので、lsコマンドの実行結果をexpectedとしてテストしたかったが、やり方が見つけられなかったのでこのテストはSkipします'
    expected = <<~TEXT.chomp
      symlink_file.txt    lorem_ipsum_2p.txt  lorem_ipsum_10p.txt dummy_file_004.txt  dummy_file_002.txt  dir_foobar
      lorem_ipsum_5p.txt  lorem_ipsum_1p.txt  dummy_file_005.txt  dummy_file_003.txt  dummy_file_001.txt
    TEXT
    display = Display.new(TARGET_PATH)
    display.list_without_dotfile
    display.list_reverse
    assert_equal expected, display.short_format_split_into_columns
  end

  def test_ls_long_format
    expected = `ls -l #{TARGET_PATH}`.chomp
    display = Display.new(TARGET_PATH)
    display.list_without_dotfile
    display.list_file_stat
    assert_equal expected, display.long_format
  end

  def test_ls_all_options
    expected = `ls -arl #{TARGET_PATH}`.chomp
    display = Display.new(TARGET_PATH)
    display.list_contain_dotfile
    display.list_reverse
    display.list_file_stat
    assert_equal expected, display.long_format
  end
end
