# frozen_string_literal: true

module Wc
  class Read
    InputData = Struct.new(:filename, :linecount, :wordcount, :stringcount)

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def make_data_structure
      data.instance_of?(Array) ? make_file_structures : make_text_structure
    end

    private

    def make_text_structure
      InputData.new('', data.count("\n"), data.split(' ').count, data.bytesize)
    end

    def make_file_structures
      files = data
      files.map do |file|
        filedata = File.new(file).read
        InputData.new(file, filedata.count("\n"), filedata.split(' ').count, filedata.bytesize)
      end
    end
  end
end
