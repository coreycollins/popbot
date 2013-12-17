require "rvm/capistrano"
require 'capistrano-unicorn'

set :application, 'Popbot'
set :repo_url, 'git@github.com:theethosapp/popbot.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/var/www/popbot'
set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

set :rvm_ruby_string, :local

after 'deploy:restart', 'unicorn:reload'    # app IS NOT preloaded
