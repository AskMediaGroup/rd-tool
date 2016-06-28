class ProjectsRestoreFromRepo < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "restoreFromRepo"
    @subcommand_full = "projects #{subcommand_action}"
    @parameters_tag = "<remote_repository> [<commit_id>]"
    @parameters_length = 1 # This is 1 here because the last parameter is optional
    @cmd_example = "#{subcommand_full} 'https://git.ask.com/ProdEng-Rundeck/rundeck-wizard' 8ff71b4"
    @description = "Restore Rundeck projects from repository, optionally: provide a git commit-id/branch to checkout if you want an older version instead of cheking out master"

  end

  def run

    remote_repository = parameters[0]
    branch = parameters.length > 1 ? parameters[1] : 'master'
    puts "Running #{subcommand_full} #{remote_repository} #{branch}"

    git = Git.new(remote_repository, @@project_definitions_directory)
    git.clone
    git.checkout branch

    rundeck = Rundeck.new
    rundeck.projects_to_zip_from_dir(@@project_definitions_directory)
    rundeck.projects_import(@@tmp_directory)

  end

end
