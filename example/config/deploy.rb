require 'bundler/capistrano'

# Load all recipes
require 'capistrano-recipes'

set :application,               "your-application-name"
set :include_www_alias,         false

# Deployment configuration
set :user,                      "deployer"
set :deploy_via,                :remote_cache
set :use_sudo,                  false

# Git configuration
set :scm,                       "git"
set :repository,                "git@github.com:yourname/your-application-name.git"
set :branch,                    fetch(:branch, "master")
#set :git_enable_submodules,     true # init git submodule

default_run_options[:pty] = true    # so we can get prompt inputs to work
ssh_options[:forward_agent] = true  # so we don't have to add the server key to github

after "deploy:finalize_update", "deploy:migrate"  # run db migrations after finalizing
after "deploy", "deploy:cleanup"                  # keep only the last 5 releases
