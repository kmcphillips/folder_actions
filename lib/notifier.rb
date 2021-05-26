# frozen_string_literal: true
module FolderActions::Notifier
  class << self
    def for_platform
      # TODO: branch on OS and capabilities
      if SystemCall.call("which", "notify-send").success?
        FolderActions::Notifier::LinuxNotifySend.new
      else
        # TODO
      end
    end
  end

  class LinuxNotifySend
    def notify(title:, body:)
      result = SystemCall.call("notify-send", title, body)
      raise FolderActions::Error, "Could not call `notify-send`: #{ result.error_result }" unless result.success?
      true
    end
  end
end
