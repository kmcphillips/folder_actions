# frozen_string_literal: true
class FolderActions::Watcher
  attr_reader :entries

  def initialize
    @entries = []
    @inotify = INotify::Notifier.new
  end

  def add_entry(entry)
    # TODO
  end

  def run
    # TODO
  end

  private

  attr_reader :inotify
end
