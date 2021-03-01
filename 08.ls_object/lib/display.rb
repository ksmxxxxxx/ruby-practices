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
    one_liner ? short_format_oneline : short_format_split_into_columns
  end

  def short_format_oneline
    insert_file_name(files)
  end

  def short_format_split_into_columns
    transpose_files_row.map { |row| insert_file_name(row).rstrip }.join("\n")
  end

  def list_reverse
    files.reverse!
  end

  def list_sort
    files.sort!
  end

  def list_file_stat
    @file_stats = list.file_stats
  end

  def list_contain_dotfile
    @files = list.contain_dotfile
  end

  def list_without_dotfile
    @files = list.without_dotfile
  end

  private

  attr_reader :list, :files, :file_stats

  def one_liner
    num_of_lines_needed == 1
  end

  def insert_file_name(files)
    files.map { |file| file.ljust(max_name_length, ' ') }.join(' ')
  end

  def render_long_format
    file_stats.map do |file|
      long_format_of(file)
    end.join("\n")
  end

  def long_format_of(file)
    [
      file.filetype_permission,
      file.nlink.rjust(column_max_width(:nlink) + 2, ' '),
      ' ',
      file.uid.ljust(column_max_width(:uid) + 2, ' '),
      file.gid.ljust(column_max_width(:gid) + 2, ' '),
      file.size.rjust(column_max_width(:size), ' '),
      ' ',
      file.last_modified.rjust(column_max_width(:last_modified), ' '),
      ' ',
      file.name_or_symlink
    ].join
  end

  def column_max_width(attribute)
    file_stats.map { |file| file.public_send(attribute).length }.max
  end

  def blocks
    file_stats.sum(&:blocks)
  end

  def transpose_files_row
    rows = files.each_slice(num_of_lines_needed).to_a

    if rows.last.size < num_of_lines_needed
      num_of_insert_blank = num_of_lines_needed - rows.last.size
      num_of_insert_blank.times { rows.last << '' }
    end

    rows.transpose
  end

  def num_of_lines_needed
    need_to_add_line ? num_of_lines + 1 : num_of_lines
  end

  def need_to_add_line
    !when_balance_of_file_count_of_column ||
      when_over_length_than_terminal_width ||
      when_over_length_than_terminal_width_and_balance_of_count_of_column
  end

  def when_over_length_than_terminal_width
    columns_length > terminal_width
  end

  def when_over_length_than_terminal_width_and_balance_of_count_of_column
    when_over_length_than_terminal_width && !when_balance_of_file_count_of_column
  end

  def when_balance_of_file_count_of_column
    (files.count % column_count).zero?
  end

  def num_of_lines
    (files.count / column_count.to_f).round
  end

  def columns_length
    (max_name_length + 1) * column_count
  end

  def column_count
    if max_name_length <= 7
      (terminal_width / 8.to_f).round
    elsif max_name_length <= 15
      (terminal_width / 16.to_f).round
    elsif max_name_length <= 23
      (terminal_width / 24.to_f).round
    elsif max_name_length > 24
      (terminal_width / max_name_length.to_f).round
    end
  end

  def max_name_length
    files.group_by(&:length).max.first
  end

  def terminal_width
    IO.console_size[1]
  end
end
