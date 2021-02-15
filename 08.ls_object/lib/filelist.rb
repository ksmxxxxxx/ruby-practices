# frozen_string_literal: true

require_relative 'filedata'

class FileList
  attr_reader :dirname, :files

  def initialize(dirname)
    @dirname = dirname || Dir.pwd
  end

  def file_stat
    files.map { |fname| FileData.new(dirname, fname) }
  end

  def contain_dotfile
    @files = Dir.glob('*', File::FNM_DOTMATCH, base: dirname).sort
  end

  def without_dotfile
    @files = Dir.glob('*', base: dirname).sort
  end
end
