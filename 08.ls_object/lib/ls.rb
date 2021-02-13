#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'optparse'
require 'io/console/size'

require_relative 'filedata'
require_relative 'filelist'
require_relative 'display'

class Ls
  attr_reader :display

  def call
    options = parse_options
    target = ARGV[0] || '.'

    return print "ls: #{target} : No such file or directory" unless File.exist?(target)

    @display = Display.new(target)

    options.key?(:a) ? display.list_contain_dotfile : display.list_without_dotfile
    display.list_reverse if options.key?(:r)
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

puts Ls.new.call
