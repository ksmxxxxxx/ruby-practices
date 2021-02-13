#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'optparse'
require 'io/console/size'

require_relative 'filedata'
require_relative 'filelist'
require_relative 'show'

class Ls
  attr_reader :show

  def call
    options = parse_options

    return print "ls: #{ARGV[0]} : No such file or directory" unless File.exist?(ARGV[0] || '.')

    @show = Show.new(ARGV[0])

    options.key?(:a) ? show.list_contain_dotfile : show.list_without_dotfile
    show.list_reverse if options.key?(:r)
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
    show.one_liner? ? show.short_format : show.short_format_split_into_columns
  end

  def long_format
    show.list_file_stat
    show.long_format
  end
end

puts Ls.new.call
