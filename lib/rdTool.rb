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

# Dynamic require libraries under methods require_*
require 'date'
require 'fileutils'

class Rdtool

  @@separation_length = 90
  @@left_identation_length  = 2
  @@separation_char  = " "
  @@subcommands = nil

  attr_reader :args, :subcommand_dir, :parent_directory, :script_name, :context, :subcommand, :parameters
  attr_writer :context, :subcommand, :parameters

  def initialize(args, script_name)

    @args = args
    @subcommand_dir = 'subcommands'
    @script_name = File.basename(script_name)

    @context = nil
    @subcommand =  nil
    @parameters = nil

    require_libs
    require_subcommands
    print_usage unless arguments_valid?(args)

  end

  def arguments_valid?(args)
    
    is_valid = false
    return is_valid if args.length < 3
 
    self.context = args.shift.dup
    self.subcommand =  args.shift.dup
    self.parameters = args.dup

    args_subcommand_full = [context,subcommand].join(' ')

    subcommands.each do |obj|      
      if args_subcommand_full == obj.subcommand_full and args.length >= obj.parameters_length 
        is_valid = true
      end
    end
      return is_valid
  end

  def subcommands_files
    files = Dir.glob(File.expand_path(File.join(my_directory, subcommand_dir, "/*.rb")))
    return files
  end

  def libs_files
    files = Dir.glob(File.expand_path(File.join(my_directory, "/*.rb")))
    return files
  end

  def require_subcommands
    subcommands_files.each {|file| require file }
  end

  def require_libs
    libs_files.each {|file| require file }
  end

  def my_directory
    File.dirname(__FILE__)
  end

  def subcommands

    if @@subcommands.nil?
      sub = []
      subcommands_files.each do |sub_action| 
        sub_action = extract_class_name_from_path(sub_action)
        obj = Object.const_get(sub_action).new
        sub.push(obj)
      end
        @@subcommands = sub
        return sub
     end
      return @@subcommands
  end

  def extract_class_name_from_path(path)
      file_name = File.basename(path)
      file_name.slice!(".rb")

      context = file_name.split('_')[0]
      sub = file_name.split('_')[1]

      class_name = "#{upcase_first_letter(context)}#{upcase_first_letter(sub)}"
      return class_name
  end
  
  def upcase_first_letter(str)
    str[0] = str[0].upcase
    return str
  end

  def left_ident(str)
    @@separation_char * @@left_identation_length + str
  end

  def available_subcommands
    desc = []
    subcommands.each do |obj|
      desc_str = "#{obj.subcommand_full} #{obj.parameters_tag}"
      desc.push(left_ident("#{desc_str}#{@@separation_char * (@@separation_length - desc_str.length)}#{obj.description}"))
    end
      return desc.sort
  end

  def examples
    exm = []
    subcommands.each do |obj|
      exm.push(left_ident("#{script_name} #{obj.cmd_example}"))
    end
      return exm.sort
  end

  def print_usage
    puts ""
    puts "Usage: #{script_name} SUBCOMMAND SUBCOMMAND <parameter> [<parameter>]"
    puts "#{script_name} requires at least Rundeck 2.6.0"
    puts ""
    puts "Available subcommands:"
    puts ""
    puts available_subcommands
    puts ""
    puts "Examples:"
    puts ""
    puts examples
    puts ""
    exit(1)
  end

  def run()
    subcommand_context = upcase_first_letter(context)
    subcommand_action = upcase_first_letter(subcommand)
    action_obj = Object.const_get("#{subcommand_context}#{subcommand_action}").new(parameters)
    action_obj.run
  end

end
