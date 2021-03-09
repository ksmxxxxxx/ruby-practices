# frozen_string_literal: true

require_relative 'read'
require_relative 'calculation'

class Display
  def initialize(data)
    read = Read.new(data)
    @data = read.make_data_structure
    @calc = Calculation.new(data)
  end

  def show_wordcount
    if specified_file?
      if multiple_files?
        format_wordcount_specified_file_with_total
      else
        format_wordcount_specified_file
      end
    else
      format_wordcount
    end
  end

  def show_linecount
    if specified_file?
      if multiple_files?
        format_linecount_specified_file_with_total
      else
        format_linecount_specified_file
      end
    else
      format_linecount
    end
  end

  private

  attr_reader :data, :calc

  def format_wordcount_specified_file_with_total
    [
      format_wordcount_specified_file,
      "\n",
      calc.decorate_linecount_total.to_s.rjust(8, ' '),
      calc.decorate_wordcount_total.to_s.rjust(8, ' '),
      calc.decorate_stringcount_total.to_s.rjust(8, ' '),
      ' ',
      'total'
    ].join
  end

  def format_wordcount_specified_file
    data.map do |d|
      [
        d.linecount.to_s.rjust(8, ' '),
        d.wordcount.to_s.rjust(8, ' '),
        d.stringcount.to_s.rjust(8, ' '),
        ' ',
        d.filename
      ].join
    end.join("\n")
  end

  def format_wordcount
    [
      data.linecount.to_s.rjust(8, ' '),
      data.wordcount.to_s.rjust(8, ' '),
      data.stringcount.to_s.rjust(8, ' ')
    ].join
  end

  def format_linecount_specified_file_with_total
    [
      format_linecount_specified_file,
      "\n",
      calc.decorate_linecount_total.to_s.rjust(8, ' '),
      ' ',
      'total'
    ].join
  end

  def format_linecount_specified_file
    data.map do |d|
      [
        d.linecount.to_s.rjust(8, ' '),
        ' ',
        d.filename
      ].join
    end.join("\n")
  end

  def format_linecount
    data.linecount.to_s.rjust(8, ' ')
  end

  def multiple_files?
    data.count >= 2
  end

  def specified_file?
    data.instance_of?(Array)
  end
end
