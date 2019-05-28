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

class ProjectExportToInstance < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "exportToInstance"
    @subcommand_full = "project #{subcommand_action}"
    @parameters_tag = "<project_name> <rundeck_api_endpoint> [del_proj] [imp_exec]"
    @parameters_length = 2 # This is 2 here because the other parameters are optional
    @cmd_example = "#{subcommand_full} foo_project https://rundeck.foo.bar true false"
    @description = "Export Rundeck project to another Rundeck instance, optionally: delete project and import executions as boolean flags"

  end

  def run

    project_name = parameters[0]
    rundeck_endpoint = parameters[1]

    if parameters.length > 2
        delete_project_before_import = parameters[2].to_bool
        import_executions = parameters[3].to_bool
    else
        delete_project_before_import = true
        import_executions = true
    end

    puts "Running #{subcommand_full} #{project_name} #{rundeck_endpoint} #{delete_project_before_import} #{import_executions}"

    local_project_file = File.join(@@tmp_directory,project_name)
    rundeck = Rundeck.new
    rundeck.project_to_file(project_name, local_project_file)
    
    rundeck = Rundeck.new(rundeck_endpoint)
    rundeck.project_import(local_project_file, delete_project_before_import, import_executions)

  end

end
