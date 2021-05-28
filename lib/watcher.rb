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
      inotify.watch(path, *entry.operation) do |event|
        actor = if entry.action_class
          raise "not implemented" # TODO
        elsif entry.command.present?
          FolderActions::Actor::CommandActor.new(file_name: event.name, file_path: event.watcher.path, entry: entry)
        else
          raise "not implemented" # TODO
        end

        if actor.triggered?
          puts "#{ event.flags.map(&:to_s).join("/") } #{ actor.file_path }"

          actor.run

          if actor.success?
            notifier.notify(**actor.notification)
            FileUtils.rm(actor.file) if actor.delete_original?
          else
            puts "Error processing #{ actor.file_name } with #{ actor }"
            notifier.notify(**actor.notification)
          end
        end
      end
    end
  end

  def run
    inotify.run
  end

  private

  attr_reader :inotify, :notifier
end
