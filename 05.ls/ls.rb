#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'optparse'

def ls(files_name)
  opt = OptionParser.new
  opt.on('-l')
  opt.on('-r')
  opt.on('-a')
  options = opt.getopts
  path = File.expand_path(files_name[0] || '')

  unless Dir.exist?(path)
    puts "#{files_name[0]} : No such file or directory"
    return
  end
  puts output_file_list(path, options)
end

def output_file_list(path, options)
  if options['l']
    output_long_list(path, options)
  else
    output_segment(path, options)
  end
end

def output_long_list(path, options)
  directory_files_list = data_of_directory_files(path, options)

  return if directory_files_list.empty?

  max_filetype_permission_length = max_filetype_permission_length(directory_files_list)
  max_hardlink_length = max_hardlink_length(directory_files_list)
  max_userid_length = max_userid_length(directory_files_list)
  max_groupid_length = max_groupid_length(directory_files_list)
  max_filesize_length = max_filesize_length(directory_files_list)
  max_timestamp_length = max_timestamp_length(directory_files_list)

  puts "total #{blocks(directory_files_list)}"
  directory_files_list.map do |d|
    (d[:filetype_permission]).ljust(max_filetype_permission_length, ' ') +
      d[:hardlink].to_s.rjust(max_hardlink_length + 2, ' ') + ' ' +
      d[:uid].ljust(max_userid_length + 2, ' ') +
      d[:gid].ljust(max_groupid_length + 2, ' ') +
      d[:filesize].to_s.rjust(max_filesize_length, ' ') + ' ' +
      d[:timestamp].rjust(max_timestamp_length, ' ') + ' ' +
      d[:name_or_symlink]
  end
end

def max_filetype_permission_length(directory_files_list)
  directory_files_list.map { |hash| hash[:filetype_permission].length }.max
end

def max_hardlink_length(directory_files_list)
  directory_files_list.map { |hash| hash[:hardlink].to_s.length }.max
end

def max_userid_length(directory_files_list)
  directory_files_list.map { |hash| hash[:uid].length }.max
end

def max_groupid_length(directory_files_list)
  directory_files_list.map { |hash| hash[:gid].length }.max
end

def max_filesize_length(directory_files_list)
  directory_files_list.map { |hash| hash[:filesize].to_s.length }.max
end

def max_timestamp_length(directory_files_list)
  directory_files_list.map { |hash| hash[:timestamp].length }.max
end

def blocks(directory_files_list)
  directory_files_list.map { |hash| hash[:blocks] }.sum
end

def max_file_name_length(path, options)
  sort_file_names(path, options).group_by(&:length).max.first
end

def output_segment(path, options)
  if can_output_single_line?(path, options)
    sort_file_names(path, options).map { |file| file.ljust(max_file_name_length(path, options), ' ') }.join(' ')
  else
    display_colum_files(path, options).map do |line|
      line.map { |i| i.ljust(max_file_name_length(path, options), ' ') }.join(' ')
    end
  end
end

def display_colum_files(path, options)
  files_colum = []

  sort_file_names(path, options).each_slice(colum_line(path, options)) do |file|
    files_colum << file
  end

  if files_colum.last.count <= colum_line(path, options)
    add_item_count = colum_line(path, options) - files_colum.last.count
    add_item_count.times { files_colum.last << '' }
  end

  files_colum.transpose
end

def can_output_single_line?(path, options)
  colum_line(path, options) <= 1
end

def colum_line(path, options)
  term_width = `tput cols`.to_i
  file_count = sort_file_names(path, options).count

  colum_line = (file_count / calculate_col_width(path, options).to_f).round
  col_count = (term_width / calculate_col_width(path, options).to_f).round
  line_width = max_file_name_length(path, options) * col_count

  colum_line += 1 if line_width > term_width || colum_line.zero?
end

def calculate_col_width(path, options)
  directory_files_list = data_of_directory_files(path, options)

  return if directory_files_list.empty?

  term_width = `tput cols`.to_i
  file_name_array = []

  directory_files_list.each do |d|
    file_name_array << d[:name]
  end

  max_file_name_length = file_name_array.group_by(&:length).max.first

  if max_file_name_length <= 7
    (term_width / 8.to_f).round
  elsif max_file_name_length <= 15
    (term_width / 16.to_f).round
  elsif max_file_name_length <= 23
    (term_width / 24.to_f).round
  end
end

def sort_file_names(path, options)
  directory_files_list = data_of_directory_files(path, options)

  return if directory_files_list.empty?

  directory_files_list.map { |file| file[:name] }
end

def data_of_directory_files(path, options)
  directory_files = Dir.glob('*', File::FNM_DOTMATCH, base: path).sort

  files = directory_files.map do |file_name|
    create_data_of_file(path, file_name)
  end

  files.reject! { |d| d[:name].start_with?('.') } unless options['a']

  files.reverse! if options['r']

  files
end

def create_data_of_file(path, file_name)
  file_path = path + '/' + file_name
  fstat = File.lstat(file_path)

  { filetype_permission: filetype(fstat) + permission(fstat),
    hardlink: fstat.nlink,
    uid: Etc.getpwuid(fstat.uid).name,
    gid: Etc.getgrgid(fstat.gid).name,
    filesize: fstat.size,
    timestamp: fstat.atime.strftime('%Y %m %d %H:%M'),
    name: file_name,
    name_or_symlink: name_or_symlink(path, file_name),
    blocks: fstat.blocks }
end

def filetype(fstat)
  if fstat.ftype == 'file'
    '-'
  elsif fstat.ftype == 'directory'
    'd'
  elsif fstat.ftype == 'link'
    'l'
  end
end

def permission(fstat)
  permission_converting_code = {
    0 => '---',
    1 => '--x',
    2 => '-w-',
    3 => '-wx',
    4 => 'r--',
    5 => 'r-x',
    6 => 'rw-',
    7 => 'rwx'
  }

  owner, group, user = fstat.mode.to_s(8)[-3, 3].chars.map(&:to_i)
  permission_converting_code[owner] + permission_converting_code[group] + permission_converting_code[user]
end

def name_or_symlink(path, file_name)
  file_path = path + '/' + file_name
  fstat = File.lstat(file_path)

  if fstat.ftype == 'link'
    file_name + ' -> ' + File.readlink(file_path)
  else
    file_name
  end
end

files_name = ARGV
ls(files_name)
