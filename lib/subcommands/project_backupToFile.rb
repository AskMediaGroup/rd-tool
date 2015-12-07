class ProjectBackupToFile < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :tmp_directory, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "backupToFile"
    @subcommand_full = "project #{subcommand_action}"
    @parameters_tag = "<export_project> <export_file>"
    @parameters_length = 2
    @cmd_example = "#{subcommand_full} foo foo.zip"
    @description = "Backup Rundeck projects to a zip file"

  end

  def run

    export_file = parameters[0]
    export_project = parameters[1]

    puts "Running #{subcommand_full} #{export_file} #{export_project}"
    rundeck = Rundeck.new
    rundeck.project_to_file(export_project, export_file)

  end

end

