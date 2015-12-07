class ProjectsBackupToFile < Subcommand

  attr_reader :parameters, :subcommand_action, :subcommand_full, :description, :cmd_example, :tmp_directory, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "backupToFile"
    @subcommand_full = "projects #{subcommand_action}"
    @parameters_length = 1
    @cmd_example = "#{subcommand_full} foo.zip"
    @description = "Backup Rundeck projects to a zip file"

  end

  def run

    export_file = parameters[0]
    puts "Running #{subcommand_full} #{export_file}"
    rundeck = Rundeck.new

    rundeck.projects_to_zip(@@tmp_directory)
    MyZip.new.zip(@@tmp_directory, export_file)
    puts "Finish #{export_file}"

  end

end

