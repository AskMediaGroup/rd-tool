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

    project_name = import_file.split('.')[0]
    File.absolute_path(import_file)

    import_file_full_path = File.absolute_path(import_file)

    puts "Running #{subcommand_full} #{import_file_full_path}"
    rundeck = Rundeck.new

    begin 
        rundeck.project_delete(project_name)
    rescue
        puts "Failing to delete #{project_name}"
    end
    rundeck.project_create(project_name)
    rundeck.project_import(import_file_full_path)

  end

end
