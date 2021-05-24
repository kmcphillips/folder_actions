# frozen_string_literal: true
class FolderActions::Config::Base
  attr_reader :config, :entries

  def initialize(config)
    @config = config
    @entries = config.map { |c| Entry.new(c) }
  end

  class Entry
    attr_reader :path, :notification, :file_pattern, :delete_original, :command, :action_class, :arguments

    DEFAULT_CONFIG = {
      path: nil,
      notification: nil,
      file_pattern: nil,
      delete_original: false,
      command: nil,
      action_class: nil,
      arguments: nil,
    }.freeze

    def initialize(config)
      begin
        current = DEFAULT_CONFIG.merge(config.symbolize_keys)

        @notification = config[:notification].presence
        @delete_original = !!config[:delete_original]

        if current[:action_class].present?
          @action_class = current[:action_class].constantize
          @arguments = current[:arguments] || {}
        elsif current[:command].present?
          @command = current[:command].presence
          @file_pattern = current[:file_pattern].presence
          @path = current[:path].presence
          raise FolderActions::ConfigError, "A 'command' entry must contain a 'path'" if path.blank?
        else
          raise FolderActions::ConfigError, "Each entry must have 'action_class' or 'command'"
        end
      rescue FolderActions::ConfigError => e
        raise
      rescue => e
        raise FolderActions::ConfigError.new(e)
      end
    end
  end
end
