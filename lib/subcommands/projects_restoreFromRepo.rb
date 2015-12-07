class ProjectsRestoreFromRepo < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "restoreFromRepo"
    @subcommand_full = "projects #{subcommand_action}"
    @parameters_tag = "<remote_repository>"
    @parameters_length = 1
    @cmd_example = "#{subcommand_full} 'https://github.com/snebel29/foo-repo'"
    @description = "Restore Rundeck projects from repository"

  end

  def run

    remote_repository = parameters[0]
    puts "Running #{subcommand_full} #{remote_repository}"
  
    git = Git.new(remote_repository, @@project_definitions_directory)
    git.clone

    rundeck = Rundeck.new
    rundeck.projects_to_zip_from_dir(@@project_definitions_directory)
    rundeck.projects_import(@@tmp_directory)

  end

end
