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

class ProjectsPushToRepo < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "pushToRepo"
    @subcommand_full = "projects #{subcommand_action}"
    @parameters_tag = "<remote_repository>"
    @parameters_length = 1
    @cmd_example = "#{subcommand_full} 'git@git.foo.com:devops-rundeck/foo-repo.git'"
    @description = "Push Rundeck projects to git repository, requires a non empty repository url as parameter"

  end

  def run

    remote_repository = parameters[0]
    puts "Running #{subcommand_full} #{remote_repository}"

    git = Git.new(remote_repository, @@project_definitions_directory)
    rundeck = Rundeck.new

    git.init

    #The hard_pull then remove everything except .git is necessary to catch deletes, .git folder is not removed using Dir
    git.hard_pull 
    Dir[File.join(@@project_definitions_directory, '/*')].each { |file| Subcommand.rm_rf(file) }

    rundeck.projects_to_zip(@@tmp_directory)
    rundeck.projects_unzip_to_repo(@@tmp_directory, @@project_definitions_directory, "(\/reports\/|\/executions\/)")
    
    git.add

    if git.something_to_commit?
      git.commit
      git.push
    else
      puts "Nothing to commit"
    end

    puts "Finish"

  end

end
