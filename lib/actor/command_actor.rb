# frozen_string_literal: true
class FolderActions::Actor::CommandActor
  attr_reader :file_name, :file_path, :file, :entry

  def initialize(file_name:, file_path:, entry:)
    @file_path = file_path
    @file_name = file_name
    @file = File.join(file_path, file_name)
    raise "problem: #{ @file } should exist but it does not" unless File.exists?(@file)
    raise "problem: #{ @file } should be a file but is a directory" if File.directory?(@file)
    @entry = entry
    @ran = false
    @success = nil
    @notification = nil
  end

  def triggered?
    !entry.file_pattern || File.fnmatch(entry.file_pattern, file_name)
  end

  def run
    @ran = true

    entry.command.each do |command|
      templated_command = template(command)
      puts "Running: #{ templated_command }"
      result = SystemCall.call(templated_command)
      if !result.success?
        puts "Error: #{ result.error_result }"
        @success = false
        @notification = { title: "Folder Actions", body: "Error processing file #{ file_name } with command #{ templated_command }", error: true }

        return false
      end
    end

    @success = true
    @notification = { title: "Folder Actions", body: template(entry.notification), error: false }

    true
  end

  def success?
    @success
  end

  def notify?
    !!entry.notification
  end

  def notification
    @notification if notify?
  end

  def delete_original?
    !!entry.delete_original
  end

  def to_s
    "FolderActions::Actor::CommandActor on #{ file_name }"
  end

  private

  def template_context
    {
      file_name: file_name,
      file_path: file_path,
      file: file,
    }
  end

  def template(str)
    Handlebars::Handlebars.new.compile(str).call(template_context)
  end
end
