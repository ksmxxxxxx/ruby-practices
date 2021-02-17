# frozen_string_literal: true

require_relative 'filedata'

class FileList
  def initialize(dirname)
    @dirname = dirname || Dir.pwd
  end

  def file_stat
    files.map { |fname| FileData.new(dirname, fname) }
  end

  def contain_dotfile
    @files = Dir.glob('*', File::FNM_DOTMATCH, base: dirname)
  end

  def without_dotfile
    @files = Dir.glob('*', base: dirname)
  end

  private

  attr_reader :dirname, :files
end
