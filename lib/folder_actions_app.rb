# frozen_string_literal: true
class FolderActions::App
  attr_reader :config_files

  def initialize(config_files:)
    @config_files = config_files
    @entries = nil
  end

  def start
    # TODO
  end

  def validate
    puts "☑ Found #{ entries.count } #{ 'entry'.pluralize(entries.count) } in #{ config_files.count } #{ 'file'.pluralize(config_files.count) }."
  end

  private

  def entries
    # TODO: catch the FolderActions::ConfigError here and display a better message than a stacktrace
    @entries ||= config_files.map { |c| FolderActions::Config::YamlFile.new(file_path: File.expand_path(c)).entries }.inject(&:+)
  end
end
