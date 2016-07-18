class ProjectPromoteToInstance < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "promoteToInstance"
    @subcommand_full = "project #{subcommand_action}"
    @parameters_tag = "<project_name> <rundeck_api_endpoint> [del_proj] [api_token]"
    @parameters_length = 2
    @cmd_example = "#{subcommand_full} foo_project https://rundeck.foo.bar"
    @description = "Export Rundeck project to another Rundeck instance, node delete and no executions will be import"

  end

  def run

    project_name = parameters[0]
    rundeck_endpoint = parameters[1]

    token = parameters.length > 3 ? parameters[3] : token = nil

    delete_project_before_import = parameters.length > 2 ? parameters[2].to_bool : false
    import_executions = false

    puts "Running #{subcommand_full} #{project_name} #{rundeck_endpoint}"

    local_project_file = File.join(@@tmp_directory,project_name)
    rundeck = Rundeck.new
    rundeck.project_to_file(project_name, local_project_file)

    rundeck = Rundeck.new(rundeck_endpoint, token)
    rundeck.project_import(local_project_file, delete_project_before_import, import_executions)

    ## Force to sync Library by execution the rundeck job after promotion
    ## This execution is not followed so we don't know when this was successfull or not
    job_name = 'rundeck-synchronize-library'
    job_project = 'ADMIN'
    puts "Running #{job_name} in #{job_project}"
    rundeck.job_run_by_name(job_project, job_name)
    puts "Execution result is not verified... please verify it manually if this is important for you"

  end

end

