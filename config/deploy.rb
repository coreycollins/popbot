require "rvm/capistrano"
#require 'capistrano-unicorn'

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

set :rvm_ruby_version, '1.9.3-p484'
set :default_env, { path: "~/.rvm/bin:$PATH" }
#git commit -amSSHKit.config.command_map[:rake] = "#{fetch(:default_env)[:rvm_bin_path]}/rvm ruby-#{fetch(:rvm_ruby_version)} do bundle exec rake"

namespace :deploy do

  desc "Zero-downtime restart of Unicorn"
  task :restart, :except => { :no_release => true } do
    run "cd #{current_path}; #{sudo} kill -s USR2 `cat tmp/pids/unicorn.pid`"
  end

  desc "Start unicorn"
  task :start, :except => { :no_release => true } do
    run "cd #{current_path} ; sudo bundle exec unicorn_rails -E production -c config/unicorn.rb -D"
  end

  desc "Stop unicorn"
  task :stop, :except => { :no_release => true } do
    run "sudo kill -s QUIT `cat #{File.join(current_path,'tmp/pids/unicorn.pid')}`"
  end  
  
end
