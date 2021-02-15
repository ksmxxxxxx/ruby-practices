# frozen_string_literal: true

require 'date'

class FileData
  attr_reader :target, :file, :fs, :type, :mode, :nlink, :uid, :gid, :size, :updated_at, :blocks

  FILETYPE_CONVERTING_CODE = {
    'file' => '-',
    'directory' => 'd',
    'link' => 'l'
  }

  PERMISSION_CONVERTING_CODE = {
    0 => '---',
    1 => '--x',
    2 => '-w-',
    3 => '-wx',
    4 => 'r--',
    5 => 'r-x',
    6 => 'rw-',
    7 => 'rwx'
  }

  def initialize(target, file)
    @target = target
    @file = file
    @fs = File.lstat("#{target}/#{file}")
    @type = fs.ftype
    @mode = fs.mode
    @nlink = fs.nlink.to_s
    @uid = Etc.getpwuid(fs.uid).name
    @gid = Etc.getgrgid(fs.gid).name
    @size = fs.size.to_s
    @updated_at = fs.mtime
    @blocks = fs.blocks
  end

  def date
    if updated_at.strftime('%Y-%m-%d') <= Date.today.prev_month(6).strftime('%Y-%m-%d')
      updated_at.strftime('%_m %_d  %Y')
    else
      updated_at.strftime('%_m %_d %H:%M')
    end
  end

  def filetype_permission
    "#{filetype}#{permission}"
  end

  def filetype
    FILETYPE_CONVERTING_CODE[type]
  end

  def permission
    owner, group, user = mode.to_s(8)[-3, 3].chars.map(&:to_i)
    PERMISSION_CONVERTING_CODE[owner] + PERMISSION_CONVERTING_CODE[group] + PERMISSION_CONVERTING_CODE[user]
  end

  def name_or_symlink
    if type == 'link'
      "#{file} -> #{File.readlink("#{target}/#{file}")}"
    else
      file
    end
  end
end
