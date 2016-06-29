class JobsDeleteWithGroup < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :tmp_directory, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "deleteWithGroup"
    @subcommand_full = "jobs #{subcommand_action}"
    @parameters_tag = "<project_name> <job_group>"
    @parameters_length = 2
    @cmd_example = "#{subcommand_full} PROJECT1 Library"
    @description = "Delete all the jobs within project_origin that belongs to job_group"

  end

  def run

    project_name = parameters[0]
    job_group = parameters[1]

    puts "Running #{subcommand_full} #{project_name} #{job_group}"
    #local_project_file = File.join(@@tmp_directory,project_origin) + ".yaml"

    rundeck = Rundeck.new
    #puts "Exporting #{project_origin} #{rundeck.jobs(project_origin)}"

    #rundeck.jobs_to_file(project_origin, local_project_file)
    #puts "The file #{local_project_file} was created successfully" if File.exists?(local_project_file)

    result = rundeck.job_delete_by_group(project_name, job_group)
    exit(1) if ! result

  end

end

