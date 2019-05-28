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

class JobsCopyToProject < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :tmp_directory, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "copyToProject"
    @subcommand_full = "jobs #{subcommand_action}"
    @parameters_tag = "<project_origin> <project_destination>"
    @parameters_length = 2
    @cmd_example = "#{subcommand_full} PROJECT1 PROJECT2"
    @description = "Copy all the jobs from project_origin to project_destination, keep group hierarchy and create new UUIDs"

  end

  def run

    project_origin = parameters[0]
    project_destination = parameters[1]

    puts "Running #{subcommand_full} #{project_origin} #{project_destination}"
    local_project_file = File.join(@@tmp_directory,project_origin) + ".yaml"

    rundeck = Rundeck.new
    puts "Exporting #{project_origin} #{rundeck.jobs(project_origin)}"

    rundeck.jobs_to_file(project_origin, local_project_file)
    puts "The file #{local_project_file} was created successfully" if File.exists?(local_project_file)

    rundeck.jobs_import(project_destination, local_project_file)
    
  end

end

