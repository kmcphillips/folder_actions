# frozen_string_literal: true
class FolderActions::App
  attr_reader :config_files, :watcher

  def initialize(config_files:)
    @config_files = config_files
    @entries = nil
    @watcher = FolderActions::Watcher.new
  end

  def start
    entries
    puts "Starting #{ entries.count } #{ 'entry'.pluralize(entries.count) }..."

    entries.each do |entry|
      watcher.add_entry(entry)
      puts "  #{ entry.to_s }"
    end

    watcher.run
  end

  def validate
    begin
      entries
      puts "☑ Found #{ entries.count } #{ 'entry'.pluralize(entries.count) } in #{ config_files.count } #{ 'file'.pluralize(config_files.count) }."
    rescue FolderActions::ConfigError => e
      puts "❎ Found #{ config_files.count } #{ 'file'.pluralize(config_files.count) } but error in entry: #{ e.message }."
    end
  end

  private

  def entries
    @entries ||= config_files.map { |c|
      FolderActions::Config::YamlFile.new(file_path: File.expand_path(c)).entries
    }.inject(&:+)
  end
end
