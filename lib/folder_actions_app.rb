# frozen_string_literal: true
class FolderActions::App
  attr_reader :entries, :config_files

  def initialize(config_files:)
    @config_files = config_files.map do |config_file|
      FolderActions::Config::YamlFile.new(file_path: File.expand_path(config_file))
    end

    @entries = @config_files.map(&:entries).inject(&:+)
  end

  def start
    # TODO
  end

  def validate
    puts "☑ Found #{ entries.count } #{ 'entry'.pluralize(entries.count) } in #{ config_files.count } #{ 'file'.pluralize(config_files.count) }."
  end
end
