# frozen_string_literal: true
require "pry"
require "active_support/all"
require "logger"
require "tempfile"
require "open3"
require "yaml"
require "rb-inotify"

module FolderActions
  class << self
    def root
      @root ||= Pathname.new(File.expand_path(File.dirname(__FILE__)))
    end
  end
end

class FolderActions::Error < StandardError ; end
class FolderActions::ConfigError < FolderActions::Error ; end

require_relative "lib/config"
require_relative "lib/config/base"
require_relative "lib/config/yaml_file"

require_relative "lib/watcher"

require_relative "lib/action"
require_relative "lib/action/resize_image"

require_relative "lib/folder_actions_app"
