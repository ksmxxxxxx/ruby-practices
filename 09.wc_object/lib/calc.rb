# frozen_string_literal: true

require_relative 'read'

class Calc
  attr_reader :data

  def initialize(data)
    readfile = Read.new(data)
    @data = readfile.data_structure
  end

  def linecount_total
    data.reduce(0) { |num, item| num + item.linecount }
  end

  def wordcount_total
    data.reduce(0) { |num, item| num + item.wordcount }
  end

  def stringcount_total
    data.reduce(0) { |num, item| num + item.stringcount }
  end
end
