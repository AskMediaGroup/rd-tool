class ProjectsReplicateToInstance < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :parameters_length

  def initialize(parameters=nil)

    # Temporal Workaround for CD-60 - PLEASE REMOVE AS SOON AS WE DON'T USE
    # THIS COMMAND ANYMORE TO SYNC STANDBY INSTANCES !!!!
    OpenSSL::SSL.const_set(:VERIFY_PEER, OpenSSL::SSL::VERIFY_NONE)

    @parameters = parameters
    @subcommand_action = "replicateToInstance"
    @subcommand_full = "projects #{subcommand_action}"
    @parameters_tag = "<rundeck_api_endpoint> [api_token]"
    @parameters_length = 1
    @cmd_example = "#{subcommand_full} https://rundeck.foo.bar"
    @description = "Replicate Rundeck projects to another Rundeck instance, this action remove all existent project on target"

  end

  def run

    if parameters.length == 2
        token = parameters[1]
    else
        token = nil
    end

    rundeck_endpoint = parameters[0]
    puts "Running #{subcommand_full} #{rundeck_endpoint}"

    rundeck = Rundeck.new
    rundeck.projects_to_zip(@@tmp_directory)

    rundeck = Rundeck.new(rundeck_endpoint, token)
    rundeck.projects_delete_all
    rundeck.projects_import(@@tmp_directory)

  end

end
