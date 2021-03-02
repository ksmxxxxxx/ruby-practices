# frozen_string_literal: true

class Read
  InputData = Struct.new(:filename, :linecount, :wordcount, :stringcount)

  attr_reader :data

  def initialize(data)
    @data = data
  end

  def data_structure
    data.instance_of?(Array) ? file_stratures : text_structure
  end

  private

  def text_structure
    InputData.new('', data.count("\n"), data.split(' ').count, data.bytesize)
  end

  def file_stratures
    files = data
    files.map do |file|
      filedata = File.new(file).read
      InputData.new(file, filedata.count("\n"), filedata.split(' ').count, filedata.bytesize)
    end
  end
end
