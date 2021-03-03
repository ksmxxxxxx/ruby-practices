# frozen_string_literal: true

require_relative 'read'

class Calc
  attr_reader :data

  def initialize(data)
    readfile = Read.new(data)
    @data = readfile.make_data_structure
  end

  def makeup_linecount_total
    data.reduce(0) { |num, item| num + item.linecount }
  end

  def makeup_wordcount_total
    data.reduce(0) { |num, item| num + item.wordcount }
  end

  def makeup_stringcount_total
    data.reduce(0) { |num, item| num + item.stringcount }
  end
end
