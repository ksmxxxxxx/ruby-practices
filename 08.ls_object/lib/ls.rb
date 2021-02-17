#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

require_relative 'display'

class Ls
  attr_reader :display

  def ls
    options = parse_options
    target = ARGV[0] || '.'

    raise(ArgumentError, "#{target} is no such file or directory") unless File.exist?(target)

    @display = Display.new(target)

    options.key?(:a) ? display.list_contain_dotfile : display.list_without_dotfile
    options.key?(:r) ? display.list_reverse : display.list_sort
    options.key?(:l) ? long_format : short_format
  end

  private

  def parse_options
    opt = OptionParser.new
    params = {}

    opt.on('-a')
    opt.on('-r')
    opt.on('-l')
    opt.parse!(ARGV, into: params)
    params
  end

  def short_format
    display.one_liner? ? display.short_format : display.short_format_split_into_columns
  end

  def long_format
    display.list_file_stat
    display.long_format
  end
end

puts Ls.new.ls
