require "rvm/capistrano"
#require 'capistrano-unicorn'

set :application, 'Popbot'
set :repo_url, 'git@github.com:theethosapp/popbot.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/var/www/popbot'
set :scm, :git

set :format, :pretty
# set :log_level, :debug

set :keep_releases, 5

set :rvm_ruby_version, '1.9.3-p484'
set :default_env, { path: "~/.rvm/bin:$PATH" }
#git commit -amSSHKit.config.command_map[:rake] = "#{fetch(:default_env)[:rvm_bin_path]}/rvm ruby-#{fetch(:rvm_ruby_version)} do bundle exec rake"

namespace :deploy do

  desc "Zero-downtime restart of Unicorn"
  task :restart do
    on roles(:web) do
      execute "cd #{current_path}; sudo kill -s USR2 `cat tmp/pids/unicorn.pid`"
    end
  end

  desc "Start unicorn"
  task :start do
    on roles(:web) do
      execute "cd #{current_path} ; bundle exec unicorn_rails -E production -c config/unicorn.rb -D"
    end
  end

  desc "Stop unicorn"
  task :stop do
    on roles(:web) do
      execute "sudo kill -s QUIT `cat #{File.join(current_path,'tmp/pids/unicorn.pid')}`"
    end
  end  

end
