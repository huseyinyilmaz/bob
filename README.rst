BOB
===

Bob is a utility for:

1) Downloading fresh copy of a repository.
2) Build docker image from root directory of project.
3) Optionally push built image to a remote docker repo.

With assigning defaults with environment variables, bob becomes very usefull for people who need to build repos on fresh repos.


::

   $ bob --help
   Bob the container builder. Bob downloads git repos, build docker images and pushes them to dockerhub.

   Usage: bob (-n|--name NAME) (-b|--branch BRANCH) [-u|--repo-url REPO-URL]
              [-n|--docker-name DOCKER-NAME] [-o|--docker-owner DOCKER-OWNER]
              [-t|--docker-tag DOCKER-TAG] [-p|--push]

   Available options:
     -h,--help                Show this help text
     -n,--name NAME           Git Project Name.
     -b,--branch BRANCH       Git Branch to use for build.
     -u,--repo-url REPO-URL   URL for git repository.
     -n,--docker-name DOCKER-NAME
                              Project name on dockerhub.
     -o,--docker-owner DOCKER-OWNER
                              User name on dockerhub.
     -t,--docker-tag DOCKER-TAG
                              Docker tag for dockerhub.
     -p,--push                Push to dockerhub after build.
   $


Configuration
-------------
All the arguments except name and branch can also be provided with environment variables. So you can add the config to your bash profile.

following are the environment variables you want to set.

BOB_DOCKER_OWNER = default --docker-owner argument
BOB_<name>_REPO_URL = Repository url for given project <name> will be replaced with uppercase of --name argument from command line.
BOB_DOCKER_FILE_PATH = Docker file path. default is root directory. For instance, if your dockerfile is in ./project/ subdirectory you need to set this variable as "<name>/project"

Sample configuration.
---------------------
This is a sample configuration for a project named myproject that gets downloaded from github and pushed to dockerhub yilmazhuseyin/myproject
In .bash_profile:

::

   $ BOB_DOCKER_OWNER='yilmazhuseyin'
   $ BOB_MYPROJECT_REPO_URL=https://github.com/huseyinyilmaz/myproject.git
   # if Dockerfile is in root, you dont need to don't provide that.
   # I am assuming that Dockerfile is in config folder
   $ BOB_MYPROJECT_DOCKER_FILE_PATH=myproject/config

 After this configuration I can do following calls

::

   # Download and build yilmazhuseyin/myproject:master image from master branch.
   $ bob --name=myproject --branch=master
   # Download and build yilmazhuseyin/myproject:latest image from master branch.
   $ bob --name=myproject --branch=master --docker-tag=latest
   # Download and build yilmazhuseyin/myproject:latest image from master branch and push it to dockerhub
   $ bob --name=myproject --branch=master --docker-tag=latest --push
