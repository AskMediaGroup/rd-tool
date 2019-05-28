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

class ProjectsReplicateFromInstance < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "replicateFromInstance"
    @subcommand_full = "projects #{subcommand_action}"
    @parameters_tag = "<rundeck_api_endpoint> [api_token]"
    @parameters_length = 1
    @cmd_example = "#{subcommand_full} http://rundeck.foo.bar"
    @description = "Replicate Rundeck projects from another Rundeck instance, this action remove all existent project on the local Instance"

  end

  def run

    if parameters.length == 2
        token = parameters[1]
    else
        token = nil
    end

    rundeck_endpoint = parameters[0]
    puts "Running #{subcommand_full} #{rundeck_endpoint}"

    rundeck = Rundeck.new(rundeck_endpoint, token)
    rundeck.projects_to_zip(@@tmp_directory)

    rundeck = Rundeck.new
    rundeck.projects_delete_all
    rundeck.projects_import(@@tmp_directory)

  end

end
