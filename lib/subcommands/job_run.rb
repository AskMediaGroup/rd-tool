class JobRun < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :tmp_directory, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "run"
    @subcommand_full = "job #{subcommand_action}"
    @parameters_tag = "<project> <job_name> [<rundeck_api_endpoint>]"
    @parameters_length = 2
    @cmd_example = "#{subcommand_full} PROJECT1 MY-JOB https://myrundeckinstance.foo.bar"
    @description = "Run a job by name within an specific project, optionally specify the rundeck instance"

  end

  def run

    project_name = parameters[0]
    job_name = parameters[1]

    api_endpoint = parameters[2] if parameters.count > 2

    puts "Running #{subcommand_full} #{project_name} #{job_name} #{api_endpoint}"

    if api_endpoint.nil?
      rundeck = Rundeck.new
    else
      rundeck = Rundeck.new(api_endpoint)
    end

    rundeck.job_run_by_name(project_name, job_name)
 
  end

end

