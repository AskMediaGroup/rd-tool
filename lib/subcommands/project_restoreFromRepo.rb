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

class ProjectRestoreFromRepo < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "restoreFromRepo"
    @subcommand_full = "project #{subcommand_action}"
    @parameters_tag = "<project> <remote_repository> [<commit_id>]"
    @parameters_length = 2 # This is 2 here because the last parameter is optional
    @cmd_example = "#{subcommand_full} foo_project 'https://git.ask.com/ProdEng-Rundeck/rundeck-wizard' 8ff71b4"
    @description = "Restore Rundeck project from repository, optionally: provide a git commit-id/branch to checkout if you want an older version instead of checking out master"

  end

  def run

    project_name = parameters[0]
    remote_repository = parameters[1]
    branch = parameters.length > 2 ? parameters[2] : 'master'
    puts "Running #{subcommand_full} #{project_name} #{remote_repository} #{branch}"
  
    git = Git.new(remote_repository, @@project_definitions_directory)
    git.clone
    git.checkout branch

    rundeck = Rundeck.new
    rundeck.projects_to_zip_from_dir(@@project_definitions_directory)
    rundeck.project_import(File.join(@@tmp_directory, "#{project_name}.zip" ))

  end

end
