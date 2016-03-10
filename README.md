# rd-tool

* Rundeck tool: I wrote this little tool to allow me to perform a bunch of actions I needed which are better described on the below help

# Disclaimer
* Many stuff could be improved I know but this is my already working MVP, I just wanted to share it in case it could be useful for someone, don't hesitate to contact me if you have any suggestion.. but please be constructive :-)

```
Usage: rd-tool SUBCOMMAND SUBCOMMAND <parameter> [<parameter>]
rd-tool requires at least Rundeck 2.6.0

Available subcommands:

  executions purgeOld <days_to_keep>                                                        Remove executions older than days_to_keep
  jobs copyToAllProjects <project_origin> [<exclude_project_regexp>]                        Copy all the jobs from project_origin to all projects excluding, keep group hierarchy and create new UUIDs
  jobs copyToProject <project_origin> <project_destination>                                 Copy all the jobs from project_origin to project_destination, keep group hierarchy and create new UUIDs
  project backupToFile <export_project> <export_file>                                       Backup Rundeck projects to a zip file
  project exportToInstance <project_name> <rundeck_instance> [del_proj] [imp_exec]          Export Rundeck project to another Rundeck instance, optionally: delete project and import executions as boolean flags
  project promoteToInstance <project_name> <rundeck_instance>                               Export Rundeck project to another Rundeck instance, node delete and no executions will be import
  project restoreFromFile <import_file>                                                     Restore Rundeck project from a project zip file, assuming the file name match the project name
  projects backupToFile <export_file>                                                       Backup Rundeck projects to a zip file
  projects pushToRepo <remote_repository>                                                   Push Rundeck projects to git repository, requires a non empty repository url as parameter
  projects replicateFromInstance <rundeck_instance>                                         Replicate Rundeck projects from another Rundeck instance, this action remove all existent project on the local Instance
  projects replicateToInstance <rundeck_instance>                                           Replicate Rundeck projects to another Rundeck instance, this action remove all existent project on target
  projects restoreFromFile <import_file>                                                    Restore Rundeck projects from a previously generated backupToFile zip file
  projects restoreFromRepo <remote_repository>                                              Restore Rundeck projects from repository

Examples:

  rd-tool executions purgeOld 1
  rd-tool jobs copyToAllProjects PROJECT1 '^ADMIN$'
  rd-tool jobs copyToProject PROJECT1 PROJECT2
  rd-tool project backupToFile foo foo.zip
  rd-tool project exportToInstance foo_project rundeck.foo.bar true false
  rd-tool project promoteToInstance foo_project rundeck.foo.bar
  rd-tool project restoreFromFile foo.zip
  rd-tool projects backupToFile foo.zip
  rd-tool projects pushToRepo 'git@git.foo.com:devops-rundeck/foo-repo.git'
  rd-tool projects replicateFromInstance rundeck.foo.bar
  rd-tool projects replicateToInstance rundeck.foo.bar
  rd-tool projects restoreFromFile foo.zip
  rd-tool projects restoreFromRepo 'https://github.com/snebel29/foo-repo'

```

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

* Configure a valid token in Rundeck and set proper acl for api_token_group

```
description: API project level access control
context:
  project: '.*' # all projects
for:
  resource:
    - equals:
        kind: job
      allow: [create,delete] # allow create and delete jobs
    - equals:
        kind: node
      allow: [read,create,update,refresh] # allow refresh node sources
    - equals:
        kind: event
      allow: [read,create] # allow read/create events
  adhoc:
    - allow: [read,run,kill] # allow running/killing adhoc jobs and read output
  job:
    - allow: [create,read,update,delete,run,kill] # allow create/read/write/delete/run/kill of all jobs
  node:
    - allow: [read,run] # allow read/run for all nodes
by:
  group: api_token_group

---

description: Admin Application level access control, applies to creating/deleting projects, admin of user profiles, viewing projects and reading system information.
context:
  application: 'rundeck'
for:
  resource:
    - equals:
        kind: project
      allow: [create] # allow create of projects
    - equals:
        kind: system
      allow: [read,enable_executions,disable_executions,admin] # allow read of system info, enable/disable all executions
    - equals:
        kind: system_acl
      allow: [read,create,update,delete,admin] # allow modifying system ACL files
    - equals:
        kind: user
      allow: [admin] # allow modify user profiles
  project:
    - match:
        name: '.*'
      allow: [read,import,export,configure,delete,admin] # allow full access of all projects or use 'admin'
  project_acl:
    - match:
        name: '.*'
      allow: [read,create,update,delete,admin] # allow modifying project-specific ACL files
  storage:
    - allow: [read,create,update,delete] # allow access for /ssh-key/* storage content

by:
  group: api_token_group
```
