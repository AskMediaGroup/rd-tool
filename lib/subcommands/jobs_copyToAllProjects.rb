class JobsCopyToAllProjects < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :tmp_directory, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "copyToAllProjects"
    @subcommand_full = "jobs #{subcommand_action}"
    @parameters_tag = "<project_origin> [<exclude_project_regexp>]"
    @parameters_length = 1 # This is 1 here Because regexp is optional
    @cmd_example = "#{subcommand_full} PROJECT1 '^ADMIN$'"
    @description = "Copy all the jobs from project_origin to all projects excluding, keep group hierarchy and create new UUIDs"

  end

  def run

    project_origin = parameters[0]
    exclude_regexp = parameters[1] if parameters.length == 2 || exclude_regexp = nil

    puts "Running #{subcommand_full} #{project_origin} #{exclude_regexp}"
    local_project_file = File.join(@@tmp_directory,project_origin) + ".yaml"

    rundeck = Rundeck.new
    puts "Exporting #{project_origin} #{rundeck.jobs(project_origin)}"

    rundeck.jobs_to_file(project_origin, local_project_file)
    puts "The file #{local_project_file} was created successfully" if File.exists?(local_project_file)

    rundeck.projects.each do |project_destination|
        if exclude_regexp.nil?
            rundeck.jobs_import(project_destination, local_project_file)
        elsif project_destination !~ /#{exclude_regexp}/ and project_destination != project_origin
            rundeck.jobs_import(project_destination, local_project_file)
        else
            puts "Skipping #{project_destination}"
        end
    end
    
  end

end

