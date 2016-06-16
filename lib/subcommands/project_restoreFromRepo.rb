class ProjectRestoreFromRepo < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "restoreFromRepo"
    @subcommand_full = "project #{subcommand_action}"
    @parameters_tag = "<project> <remote_repository>"
    @parameters_length = 2
    @cmd_example = "#{subcommand_full} foo_project 'https://github.com/snebel29/foo-repo'"
    @description = "Restore Rundeck project from repository"

  end

  def run

    project_name = parameters[0]
    remote_repository = parameters[1]
    puts "Running #{subcommand_full} #{remote_repository}"
  
    git = Git.new(remote_repository, @@project_definitions_directory)
    git.clone

    rundeck = Rundeck.new
    rundeck.projects_to_zip_from_dir(@@project_definitions_directory)
    rundeck.projects_import(File.join(@@tmp_directory, "#{project_name}.zip" ))

  end

end
