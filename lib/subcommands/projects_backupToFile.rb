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

class ProjectsBackupToFile < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :tmp_directory, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "backupToFile"
    @subcommand_full = "projects #{subcommand_action}"
    @parameters_tag = "<export_file>"
    @parameters_length = 1
    @cmd_example = "#{subcommand_full} foo.zip"
    @description = "Backup Rundeck projects to a zip file"

  end

  def run

    export_file = parameters[0]
    puts "Running #{subcommand_full} #{export_file}"
    rundeck = Rundeck.new

    rundeck.projects_to_zip(@@tmp_directory)
    MyZip.new.zip(@@tmp_directory, export_file)
    puts "Finish #{export_file}"

  end

end

