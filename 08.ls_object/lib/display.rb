# frozen_string_literal: true

require 'io/console/size'
require_relative 'filelist'

class Display
  def initialize(target)
    @list = FileList.new(target)
  end

  def long_format
    list_file_stat
    total = "total #{blocks}"
    [total, *render_long_format].join("\n")
  end

  def short_format
    files.map { |f| f.ljust(max_name_length, ' ') }.join(' ')
  end

  def short_format_split_into_columns
    transpose_files_row.map do |row|
      row.map { |item| item.ljust(max_name_length, ' ') }.join(' ').rstrip
    end.join("\n")
  end

  def list_reverse
    files.reverse!
  end

  def list_sort
    files.sort!
  end

  def one_liner?
    column_line_count <= 1
  end

  # ここらへん@filesに渡しまくってるけど、一瞬メソッドのレシーバを渡せばいいだけでは？って思ったけど、ls.rbのオプションでインスタンス変数（メソッド）に入ってくる中身が変わるので、このままでいいのかも知れないとおもったけどどうなんだろう…
  def list_file_stat
    @files = list.file_stats
  end

  def list_contain_dotfile
    @files = list.contain_dotfile
  end

  def list_without_dotfile
    @files = list.without_dotfile
  end

  private

  attr_reader :list, :files

  def render_long_format
    files.map do |file|
      long_format_of(file)
    end.join("\n")
  end

  def long_format_of(file)
    [
      file.filetype_permission,
      file.nlink.rjust(column_width(:nlink) + 2, ' '),
      ' ',
      file.uid.ljust(column_width(:uid) + 2, ' '),
      file.gid.ljust(column_width(:gid) + 2, ' '),
      file.size.rjust(column_width(:size), ' '),
      ' ',
      file.date.rjust(column_width(:date), ' '),
      ' ',
      file.name_or_symlink
    ].join
  end

  def column_width(attribute)
    files.map { |file| file.public_send(attribute).length }.max
  end

  def blocks
    files.sum(&:blocks)
  end

  def transpose_files_row
    rows = files.each_slice(column_line_count).map { |f| f }

    return unless rows.last.count <= column_line_count

    count = column_line_count - rows.last.count
    count.times { rows.last << '' }
    rows.transpose
  end

  def column_line_count
    line_count = (file_count / column_count.to_f).round
    row_length = max_name_length * column_count
    row_length > terminal_width || line_count.zero? ? line_count + 1 : line_count
  end

  def column_count
    if max_name_length <= 7
      (terminal_width / 8.to_f).round
    elsif max_name_length <= 15
      (terminal_width / 16.to_f).round
    elsif max_name_length <= 23
      (terminal_width / 24.to_f).round
    end
  end

  def file_count
    files.count
  end

  def max_name_length
    files.group_by(&:length).max.first
  end

  def terminal_width
    IO.console_size[1]
  end
end
