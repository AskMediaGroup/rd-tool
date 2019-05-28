# Copyright 2019 AskMediaGroup.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class ProjectsReplicateToInstance < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "replicateToInstance"
    @subcommand_full = "projects #{subcommand_action}"
    @parameters_tag = "<rundeck_api_endpoint> [api_token]"
    @parameters_length = 1
    @cmd_example = "#{subcommand_full} https://rundeck.foo.bar"
    @description = "Replicate Rundeck projects to another Rundeck instance, this action remove all existent project on target"

  end

  def run

    # Temporal Workaround for CD-60 - PLEASE REMOVE AS SOON AS WE DON'T USE
    # THIS COMMAND ANYMORE TO SYNC STANDBY INSTANCES !!!!
    OpenSSL::SSL.const_set(:VERIFY_PEER, OpenSSL::SSL::VERIFY_NONE)

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
