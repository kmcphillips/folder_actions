# frozen_string_literal: true
class FolderActions::Watcher
  attr_reader :entries

  def initialize
    @entries = []
    @inotify = INotify::Notifier.new
    @notifier = FolderActions::Notifier.for_platform
  end

  def add_entry(entry)
    entry.path.each do |path|
      inotify.watch(path, *path.operation) do |event|
        notifier.notify(title: "Folder Actions", body: template(entry.notification)) if entry.notification
        # delete_original
        if entry.action_class
          # action_class
          # arguments
          raise "not implemented" # TODO
        elsif entry.command
          # command
          # file_pattern

        else
          raise "unknown type" # TODO
        end
      end
    end
  end

  def run
    inotify.run
  end

  private

  def template(str)
    # TODO: Moustache template
    str
  end

  attr_reader :inotify, :notifier
end
