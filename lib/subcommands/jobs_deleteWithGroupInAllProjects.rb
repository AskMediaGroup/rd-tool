class JobsDeleteWithGroupInAllProjects < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :tmp_directory, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "deleteWithGroupInAllProjects"
    @subcommand_full = "jobs #{subcommand_action}"
    @parameters_tag = "<job_group> [<exclude_project_regexp>]"
    @parameters_length = 1 # This is 1 here Because regexp is optional
    @cmd_example = "#{subcommand_full} Library '^LIBRARY$'"
    @description = "Delete all jobs beloging to job_group excluding exclude_project_regexp pattern"

  end

  def run

    job_group = parameters[0]

    if parameters.length == 2
        exclude_regexp = parameters[1]
    else
        exclude_regexp = nil
    end

    puts "Running #{subcommand_full} #{job_group} #{exclude_regexp}"
    #local_project_file = File.join(@@tmp_directory,project_origin) + ".yaml"

    any_failure = false
    rundeck = Rundeck.new
    puts "Deleting all jobs in group: #{job_group} and excluding projects: #{exclude_regexp||'nil'}"
    rundeck.projects.each do |project|
      if project !~ /#{exclude_regexp}/ || exclude_regexp.nil?
        puts "Working on project: #{project}"
        result = rundeck.job_delete_by_group(project, job_group)
        any_failure = true if ! result 
      else
        puts "Skipping project: #{project}"
      end
    end 

    exit(1) if any_failure
  end

end

