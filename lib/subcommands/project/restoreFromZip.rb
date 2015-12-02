class RestoreFromZip < Subcommand

  attr_reader :import_file, :subcommand_action, :subcommand_full, :description, :cmd_example

  def initialize(target=nil)

    @import_file = target
    @subcommand_action = "restoreFromZip"
    @subcommand_full = "project #{subcommand_action}"
    @cmd_example = "#{subcommand_full} foo.zip"
    @description = "Restore Rundeck project from a project zip file, assuming the file name match the project name, this action remove the existent project!"

  end

  def run
    
    puts "Running #{subcommand_full} #{import_file}"
    rundeck = Rundeck.new

    project_name = import_file.split('.')[0]
    begin 
        rundeck.project_delete(project_name)
    rescue
        puts "Failing to delete #{project_name}"
    end
    rundeck.project_import(project_name)

  end

end
