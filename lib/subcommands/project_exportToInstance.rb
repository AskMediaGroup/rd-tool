class ProjectExportToInstance < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "exportToInstance"
    @subcommand_full = "project #{subcommand_action}"
    @parameters_tag = "<project_name> <rundeck_instance> [del_proj] [imp_exec]"
    @parameters_length = 2 # This is 2 here because the other parameters are optional
    @cmd_example = "#{subcommand_full} foo_project rundeck.foo.bar true false"
    @description = "Export Rundeck project to another Rundeck instance, optionally: delete project and import executions as boolean flags"

  end

  def run

    project_name = parameters[0]
    rundeck_instance = parameters[1]

    if parameters.length > 2
        delete_project_before_import = parameters[2].to_bool
        import_executions = parameters[3].to_bool
    else
        delete_project_before_import = true
        import_executions = true
    end

    puts "Running #{subcommand_full} #{project_name} #{rundeck_instance} #{delete_project_before_import} #{import_executions}"

    local_project_file = File.join(@@tmp_directory,project_name)
    rundeck = Rundeck.new
    rundeck.project_to_file(project_name, local_project_file)
    
    rundeck = Rundeck.new(rundeck_instance)
    rundeck.project_import(local_project_file, delete_project_before_import, import_executions)

  end

end
