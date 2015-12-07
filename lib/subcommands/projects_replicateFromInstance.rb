class ProjectsReplicateFromInstance < Subcommand

  attr_reader :parameters, :subcommand_action, :subcommand_full, :description, :cmd_example, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "replicateFromInstance"
    @subcommand_full = "projects #{subcommand_action}"
    @parameters_length = 1
    @cmd_example = "#{subcommand_full} rundeck.foo.bar"
    @description = "Replicate Rundeck projects from another Rundeck instance, this action remove all existent project on the local Instance"

  end

  def run

    rundeck_instance = parameters[0]
    puts "Running #{subcommand_full} #{rundeck_instance}"

    rundeck = Rundeck.new(rundeck_instance)
    rundeck.projects_to_zip(@@tmp_directory)

    rundeck = Rundeck.new
    rundeck.projects_delete_all
    rundeck.projects_import(@@tmp_directory)

  end

end
