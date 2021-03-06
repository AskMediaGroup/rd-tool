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

    if parameters.length == 2
        exclude_regexp = parameters[1]
    else
        exclude_regexp = nil
    end

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

