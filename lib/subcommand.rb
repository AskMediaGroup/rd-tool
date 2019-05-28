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

class Subcommand

  def self.rm_rf(dest)
    if Dir.exists?(dest)
      puts "rm -rf #{dest}"
      FileUtils.rm_rf(dest)
    end
  end

  def self.random_string(length)
    (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).sort_by {rand}[0,length].join
  end

  def self.iso_date(date=Date.today)
    date.strftime("%Y-%m-%d")
  end

  @@tmp_directory = File.join('/tmp/rd-tool', Subcommand.random_string(12))
  @@project_definitions_directory = File.join(@@tmp_directory, 'project-definitions')
  
end

class String
  def to_bool
    return true if self =~ (/^(true|t|yes|y|1)$/i)
    return false if self.empty? || self =~ (/^(false|f|no|n|0)$/i)

    raise ArgumentError.new "invalid value: #{self}"
  end
end
