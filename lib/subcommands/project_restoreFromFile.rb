class ProjectRestoreFromFile < Subcommand

  attr_reader :import_file, :subcommand_action, :subcommand_full, :description, :cmd_example

  def initialize(target=nil)

    @import_file = target
    @subcommand_action = "restoreFromFile"
    @subcommand_full = "project #{subcommand_action}"
    @cmd_example = "#{subcommand_full} foo.zip"
    @description = "Restore Rundeck project from a project zip file, assuming the file name match the project name"

  end

  def run

    project_name = import_file.split('.')[0]
    File.absolute_path(import_file)

    import_file_full_path = File.absolute_path(import_file)

    puts "Running #{subcommand_full} #{import_file_full_path}"
    rundeck = Rundeck.new
    rundeck.project_import(import_file_full_path)

  end

end
