# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/display'

class LsTest < Minitest::Test
  TARGET_PATH = 'test/fixtures'
  TARGET_PATH_NO_SPRIT = 'test'

  def test_ls_short_format_sprit_into_column
    expected = <<~TEXT.chomp
      0123456789_0123456789_0123.md                         dummy_file_003.txt                                    lorem_ipsum_2p.txt
      0123456789_0123456789_0123456789_0123456789_012345.md dummy_file_004.txt                                    lorem_ipsum_5p.txt
      dir_foobar                                            dummy_file_005.txt                                    symlink_file.txt
      dummy_file_001.txt                                    lorem_ipsum_10p.txt
      dummy_file_002.txt                                    lorem_ipsum_1p.txt
    TEXT
    display = Display.new(TARGET_PATH)
    display.list_without_dotfile

    IO.stub(:console_size, [0, 178]) do
      assert_equal expected, display.short_format_split_into_columns
    end
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
    expected = <<~TEXT.chomp
      .                                                     dummy_file_001.txt                                    lorem_ipsum_10p.txt
      ..                                                    dummy_file_002.txt                                    lorem_ipsum_1p.txt
      0123456789_0123456789_0123.md                         dummy_file_003.txt                                    lorem_ipsum_2p.txt
      0123456789_0123456789_0123456789_0123456789_012345.md dummy_file_004.txt                                    lorem_ipsum_5p.txt
      dir_foobar                                            dummy_file_005.txt                                    symlink_file.txt
    TEXT
    display = Display.new(TARGET_PATH)
    display.list_contain_dotfile
    IO.stub(:console_size, [0, 178]) do
      assert_equal expected, display.short_format_split_into_columns
    end
  end

  def test_ls_reverse
    expected = <<~TEXT.chomp
      symlink_file.txt                                      dummy_file_005.txt                                    dir_foobar
      lorem_ipsum_5p.txt                                    dummy_file_004.txt                                    0123456789_0123456789_0123456789_0123456789_012345.md
      lorem_ipsum_2p.txt                                    dummy_file_003.txt                                    0123456789_0123456789_0123.md
      lorem_ipsum_1p.txt                                    dummy_file_002.txt
      lorem_ipsum_10p.txt                                   dummy_file_001.txt
    TEXT
    display = Display.new(TARGET_PATH)
    display.list_without_dotfile
    display.list_reverse
    IO.stub(:console_size, [0, 178]) do
      assert_equal expected, display.short_format_split_into_columns
    end
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
