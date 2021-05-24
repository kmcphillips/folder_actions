# frozen_string_literal: true
class FolderActions::Config::YamlFile < FolderActions::Config::Base
  attr_reader :file_path

  def initialize(file_path:)
    @file_path = file_path
    yaml = YAML.safe_load(File.read(file_path))
    raise FolderActions::ConfigError, "YAML config file #{ file_path } does not have an 'entries' key" unless yaml["entries"]
    super(yaml["entries"])
  end
end
