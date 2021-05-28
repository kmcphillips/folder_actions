# frozen_string_literal: true
class FolderActions::Config::Base
  attr_reader :config, :entries

  def initialize(config)
    @config = config
    @entries = config.map { |c| Entry.new(c) }
  end

  class Entry
    attr_reader :path, :notification, :file_pattern, :delete_original, :command, :action_class, :arguments, :operation

    DEFAULT_CONFIG = {
      path: nil,
      notification: nil,
      file_pattern: nil,
      delete_original: false,
      command: nil,
      action_class: nil,
      arguments: nil,
      operation: ["create"],
    }.freeze
    VALID_OPERATION = [ "create", "update" ].freeze

    def initialize(config)
      begin
        current = DEFAULT_CONFIG.merge(config.symbolize_keys)

        @path = Array(current[:path]).map { |p| File.expand_path(p) }
        @path.each do |p|
          raise FolderActions::ConfigError, "'path' #{ p } does not exist" unless File.exists?(p)
          raise FolderActions::ConfigError, "'path' #{ p } is not a directory" unless File.directory?(p)
        end

        @operation = Array(current[:operation]).map(&:to_s).map(&:downcase)
        @operation.each do |o|
          raise FolderActions::ConfigError, "'operation' must be one of #{ VALID_OPERATION }" unless VALID_OPERATION.include?(o)
        end
        raise FolderActions::ConfigError, "'operation' must be one of #{ VALID_OPERATION }" if @operation.empty?

        @notification = current[:notification].presence
        @delete_original = !!current[:delete_original]

        if current[:action_class].present?
          @action_class = current[:action_class].constantize
          @arguments = current[:arguments] || {}
        elsif current[:command].present?
          @command = Array(current[:command]).map(&:presence)
          @file_pattern = current[:file_pattern].presence
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

    def to_s
      tokens = [
        "Watch",
        path.join(" "),
        "on",
        operation.join("/"),
        "and",
      ]

      if action_class
        tokens << "use #{ action_class } with #{arguments}"
      elsif command
        tokens << "call \"#{ command }\""
        tokens << "on #{ file_pattern }" if file_pattern
      else
        # TODO
        "unkown action?"
      end

      tokens << "and notify" if notification

      tokens.reject(&:blank?).join(" ")
    end
  end
end
