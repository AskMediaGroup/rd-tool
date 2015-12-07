class ProjectsRestoreFromFile < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :parameters_length

  def initialize(parameters=nil)

    @parameters= parameters
    @subcommand_action = "restoreFromFile"
    @subcommand_full = "projects #{subcommand_action}"
    @parameters_tag = "<import_file>"
    @parameters_length = 1
    @cmd_example = "#{subcommand_full} foo.zip"
    @description = "Restore Rundeck projects from a previously generated backupToFile zip file"

  end

  def run

    import_file = parameters[0]
    puts "Running #{subcommand_full} #{import_file}"
    MyZip.new.unzip(import_file, @@tmp_directory)
    Rundeck.new.projects_import(@@tmp_directory)

  end

end
