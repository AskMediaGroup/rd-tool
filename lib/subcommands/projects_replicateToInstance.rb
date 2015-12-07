class ProjectsReplicateToInstance < Subcommand

  attr_reader :rundeck_instance, :subcommand_action, :subcommand_full, :description, :cmd_example, :parameters_length

  def initialize(target=nil)

    @rundeck_instance = target[0]
    @subcommand_action = "replicateToInstance"
    @subcommand_full = "projects #{subcommand_action}"
    @parameters_length = 1
    @cmd_example = "#{subcommand_full} rundeck.foo.bar"
    @description = "Replicate Rundeck projects to another Rundeck instance, this action remove all existent project on target"

  end

  def run

    puts "Running #{subcommand_full} #{rundeck_instance}"

    rundeck = Rundeck.new
    rundeck.projects_to_zip(@@tmp_directory)

    rundeck = Rundeck.new(rundeck_instance)
    rundeck.projects_delete_all
    rundeck.projects_import(@@tmp_directory)

  end

end
