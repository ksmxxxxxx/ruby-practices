# frozen_string_literal: true

require 'etc'
require 'date'

class FileData
  FILETYPE_ABBREV = {
    'file' => '-',
    'directory' => 'd',
    'link' => 'l'
  }.freeze

  PERMISSION_LABELS = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  attr_reader :target, :file, :type, :mode, :nlink, :uid, :gid, :size, :updated_at, :blocks

  def initialize(target, file)
    @target = target
    @file = file
    @file_path = "#{target}/#{file}"
    fs = File.lstat(@file_path)
    @type = fs.ftype
    @mode = fs.mode
    @nlink = fs.nlink.to_s
    @uid = Etc.getpwuid(fs.uid).name
    @gid = Etc.getgrgid(fs.gid).name
    @size = fs.size.to_s
    @updated_at = fs.mtime
    @blocks = fs.blocks
  end

  def last_modified
    time_or_year = older_than_month?(6) ? ' %Y' : '%H:%M'
    updated_at.strftime("%_m %_d #{time_or_year}")
  end

  def older_than_month?(month)
    updated_at.to_date <= Date.today.prev_month(month)
  end

  def filetype_permission
    "#{filetype}#{permission}"
  end

  def filetype
    FILETYPE_ABBREV[type]
  end

  def permission
    octal_digits = mode.to_s(8)[-3, 3].chars
    octal_digits.map { |oct| PERMISSION_LABELS[oct] }.join
  end

  def name_or_symlink
    type == 'link' ? "#{file} -> #{symlink_destnation}" : file
  end

  private

  def symlink_destnation
    File.readlink(@file_path)
  end
end
