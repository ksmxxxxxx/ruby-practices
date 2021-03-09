# frozen_string_literal: true

require_relative 'read'

module Wc
  class Calculation
    attr_reader :data

    def initialize(data)
      readfile = Read.new(data)
      @data = readfile.make_data_structure
    end

    def decorate_linecount_total
      data.reduce(0) { |num, item| num + item.linecount }
    end

    def decorate_wordcount_total
      data.reduce(0) { |num, item| num + item.wordcount }
    end

    def decorate_stringcount_total
      data.reduce(0) { |num, item| num + item.stringcount }
    end
  end
end
