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

    local_project_file = File.join(@@tmp_directory, project_name)
    rundeck = Rundeck.new
    rundeck.project_to_file(project_name, local_project_file)

    rundeck = Rundeck.new(rundeck_endpoint, token)
    rundeck.project_import(local_project_file, delete_project_before_import, import_executions)

    # Sync Library for the promoted job, includes delete and import again from destination instance
    result = rundeck.job_delete_by_group(project_name, 'Library')
    puts "Warning: Deleting #{job_group} group within #{project_name}" if ! result
    
    library_project = 'LIBRARY'
    local_project_file = File.join(@@tmp_directory, library_project) + ".yaml"
    puts "Exporting #{library_project} jobs: #{rundeck.jobs(library_project)}"
    rundeck.jobs_to_file(library_project, local_project_file)
    puts "The file #{local_project_file} was created successfully" if File.exists?(local_project_file)
    puts "Import jobs on #{project_name}"
    rundeck.jobs_import(project_name, local_project_file)
    
  end

end

