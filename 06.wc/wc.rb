# frozen_string_literal: true

require 'optparse'

Input = Struct.new(:filename, :linecount, :wordcount, :stringcount)

def show_word_count(input)
  opt = OptionParser.new
  opt.on('-l')
  options = opt.getopts

  count_data = create_data_struct(input)

  if options['l']
    if ARGV == []
      count_data = create_data_struct($stdin.read)
      file_name = count_data.filename
      line_count = count_data.linecount
      word_count = count_data.wordcount
      string_count = count_data.stringcount

      puts display_line_count(file_name, line_count, word_count, string_count)
    else
      linecount_total_num = linecount_total(count_data)
      count_data.map do |struct|
        file_name = struct.filename
        line_count = struct.linecount
        word_count = struct.wordcount
        string_count = struct.stringcount

        puts display_line_count(file_name, line_count, word_count, string_count)
      end
      if multiple_specified_file?(count_data)
        puts linecount_total_num.to_s.rjust(8, ' ') + ' ' + 'total'
      end
    end
  else
    if ARGV == []
      file_name = count_data.filename
      line_count = count_data.linecount
      word_count = count_data.wordcount
      string_count = count_data.stringcount

      puts display_word_count(file_name, line_count, word_count, string_count)
    else
      linecount_total_num = linecount_total(count_data)
      count_data.map do |struct|
        file_name = struct.filename
        line_count = struct.linecount
        word_count = struct.wordcount
        string_count = struct.stringcount

        puts display_word_count(file_name, line_count, word_count, string_count)
      end
      if multiple_specified_file?(count_data)
        puts display_word_count_total_number(count_data)
      end
    end
  end
end

def multiple_specified_file?(count_data)
  count_data.size > 1
end

def display_word_count(file_name, line_count, word_count, string_count)
  if file_name
    line_count.to_s.rjust(8, ' ') +
      word_count.to_s.rjust(8, ' ') +
      string_count.to_s.rjust(8, ' ') +
      ' ' + file_name
  else
    line_count.to_s.rjust(8, ' ') +
      word_count.to_s.rjust(8, ' ') +
      string_count.to_s.rjust(8, ' ')
  end
end

def display_word_count_total_number(count_data)
  linecount_total_num = linecount_total(count_data)
  wordcount_total_num = wordcount_total(count_data)
  stringcount_total_num = stringcount_total(count_data)
  linecount_total_num.to_s.rjust(8, ' ') +
    wordcount_total_num.to_s.rjust(8, ' ') +
    stringcount_total_num.to_s.rjust(8, ' ') +
    ' ' + 'total'
end

def display_line_count(file_name, line_count, word_count, string_count)
  if file_name
    line_count.to_s.rjust(8, ' ') +
      ' ' + file_name
  else
    line_count.to_s.rjust(8, ' ')
  end
end

def linecount_total(count_data)
  filesdata = count_data

  filesdata.reduce(0) { |num, data| num + data.linecount }
end

def wordcount_total(count_data)
  filesdata = count_data

  filesdata.reduce(0) { |num, data| num + data.wordcount }
end

def stringcount_total(count_data)
  filesdata = count_data

  filesdata.reduce(0) { |num, data| num + data.stringcount }
end

def create_data_struct(input)
  if input.class == String
    Input.new('', input.count("\n"), input.split(' ').count, input.size)
  else
    files = input

    files.map do |file|
      data = File.new(file).read
      Input.new(file, data.count("\n"), data.split(' ').count, data.size)
    end
  end
end

if ARGV == []
  show_word_count($stdin.read)
else
  show_word_count(ARGV)
end
