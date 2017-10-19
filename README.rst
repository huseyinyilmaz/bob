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
