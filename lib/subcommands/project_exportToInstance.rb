class ProjectExportToInstance < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "exportToInstance"
    @subcommand_full = "project #{subcommand_action}"
    @parameters_tag = "<project_name> <rundeck_instance>"
    @parameters_length = 2
    @cmd_example = "#{subcommand_full} foo_project  rundeck.foo.bar"
    @description = "Export Rundeck project to another Rundeck instance"

  end

  def run

    project_name = parameters[0]
    rundeck_instance = parameters[1]

    puts "Running #{subcommand_full} #{project_name} #{rundeck_instance}"

    local_project_file = File.join(@@tmp_directory,project_name)
    rundeck = Rundeck.new
    rundeck.project_to_file(project_name, local_project_file)
    
    rundeck = Rundeck.new(rundeck_instance)
    rundeck.project_import(local_project_file)

  end

end
