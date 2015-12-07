class ProjectBackupToFile < Subcommand

  attr_reader :export_file, :subcommand_action, :subcommand_full, :description, :cmd_example, :tmp_directory, :parameters_length

  def initialize(target=nil)

    @export_file = target[0]
    @export_project = target[1]
    @subcommand_action = "backupToFile"
    @subcommand_full = "project #{subcommand_action}"
    @parameters_length = 2
    @cmd_example = "#{subcommand_full} foo foo.zip"
    @description = "Backup Rundeck projects to a zip file"

  end

  def run

    puts "Running #{subcommand_full} #{export_file}"
    rundeck = Rundeck.new

  end

end

