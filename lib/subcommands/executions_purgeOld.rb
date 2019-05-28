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

class ExecutionsPurgeOld < Subcommand

  attr_reader :parameters, :parameters_tag, :subcommand_action, :subcommand_full, :description, :cmd_example, :tmp_directory, :parameters_length

  def initialize(parameters=nil)

    @parameters = parameters
    @subcommand_action = "purgeOld"
    @subcommand_full = "executions #{subcommand_action}"
    @parameters_tag = "<days_to_keep>"
    @parameters_length = 1
    @cmd_example = "#{subcommand_full} 1"
    @description = "Remove executions older than days_to_keep"

  end

  def run

    days_to_keep = parameters[0]
    puts "Running #{subcommand_full} #{days_to_keep}"

    rundeck = Rundeck.new
    puts rundeck.purge_executions(days_to_keep.to_i)
    
  end

end

