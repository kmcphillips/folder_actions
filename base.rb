# frozen_string_literal: true
require "pry"
require "active_support/all"
require "logger"
require "tempfile"
require "ruby-handlebars"
require "yaml"
require "rb-inotify"
require "systemcall"
require "fileutils"

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

require_relative "lib/notifier"
require_relative "lib/watcher"

require_relative "lib/action"
require_relative "lib/action/resize_image"

require_relative "lib/actor"
require_relative "lib/actor/command_actor"

require_relative "lib/folder_actions_app"
