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
        file_name = event.name
        file_path = File.join(event.watcher.path, file_name)

        puts "triggered #{ entry } on #{ file_path }"

        if entry.action_class
          # action_class
          # arguments
          raise "not implemented" # TODO
        elsif entry.command
          if !entry.file_pattern || File.fnmatch(entry.file_pattern, file_name)
            puts "#{ event.flags.map(&:to_s).join("/") } #{ file_path }"

            # command
            success = true

            if success
              if entry.notification
                notifier.notify(title: "Folder Actions", body: template(entry.notification, entry: entry, file: file_path))
              end

              if entry.delete_original
                FileUtils.rm(file_path)
              end
            else
              puts "Error processing #{ file_name } with command: #{ entry.command }"

              if entry.notification
                notifier.notify(title: "Folder Actions", body: "Error processing file #{ file_name } with command #{ entry.command }", error: true)
              end
            end
          end
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

  def template(str, entry:, file:)
    ctx = {
      file_name: File.basename(file),
      file_path: File.expand_path(file),
    }

    Handlebars::Handlebars.new.compile(str).call(ctx)
  end

  attr_reader :inotify, :notifier
end
