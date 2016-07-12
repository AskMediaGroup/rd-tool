class ProjectsList < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :tmp_directory, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "list"
    @subcommand_full = "projects #{subcommand_action}"
    @parameters_tag = "all"
    @parameters_length = 1
    @cmd_example = "#{subcommand_full} all"
    @description = "List all projects in the current instance"

  end

  def run

    rundeck = Rundeck.new
    rundeck.projects.each { |project| puts project }

  end

end

