class ProjectRestoreFromFile < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "restoreFromFile"
    @subcommand_full = "project #{subcommand_action}"
    @parameters_tag = "<import_file>"
    @parameters_length = 1
    @cmd_example = "#{subcommand_full} foo.zip"
    @description = "Restore Rundeck project from a project zip file, assuming the file name match the project name"

  end

  def run

    import_file = parameters[0]
    project_name = import_file.split('.')[0]
    File.absolute_path(import_file)

    import_file_full_path = File.absolute_path(import_file)

    puts "Running #{subcommand_full} #{import_file_full_path}"
    rundeck = Rundeck.new
    rundeck.project_import(import_file_full_path)

  end

end
