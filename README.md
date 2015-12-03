# rd-tool

* Rundeck tool: I wrote this little tool to allow me to perform a bunch of actions I needed which are better described on the below help

# Requirements
* Tested just under Ruby >= 2.0.0 
* git installed
* Add a working Rundeck token to config.yaml file
* The following non default gems should be installed
  * zip
  * rest-client
```
gem install zip
gem install rest-client
```

# Disclaimer
* Many stuff could be improved I know but this is my already working MVP, I just wanted to share it in case it could be useful for someone, don't hesitate to contact me if you have any suggestion.. but please be constructive :-)

```
Usage: rd-tool SUBCOMMAND SUBCOMMAND TARGET
rd-tool requires at least Rundeck 2.6.0 and a valid token within token.yaml file

Available subcommands:

  projects replicateToInstance                      Replicate Rundeck projects to another Rundeck instance, this action remove all existent project on target
  projects backupToFile                             Backup Rundeck projects to a zip file
  projects replicateFromInstance                    Replicate Rundeck projects from another Rundeck instance, this action remove all existent project on the local Instance
  projects restoreFromFile                          Restore Rundeck projects from a previously generated backupToFile zip file, this action remove all existent project
  projects pushToRepo                               Push Rundeck projects to git repository, requires a valid non empty ssh connection string to a repository as parameter, an empty README.md file would be enough
  projects restoreFromRepo                          Restore Rundeck projects from repository, this action remove all existent projects on the local instance
  project restoreFromZip                            Restore Rundeck project from a project zip file, assuming the file name match the project name, this action remove the existent project!

Examples:

  ruby rd-tool projects replicateToInstance rundeck.foo.bar
  ruby rd-tool projects backupToFile foo.zip
  ruby rd-tool projects replicateFromInstance rundeck.foo.bar
  ruby rd-tool projects restoreFromFile foo.zip
  ruby rd-tool projects pushToRepo 'git@git.foo.com:devops-rundeck/foo-repo.git'
  ruby rd-tool projects restoreFromRepo 'https://github.com/snebel29/foo-repo'
  ruby rd-tool project restoreFromZip foo.zip
```
