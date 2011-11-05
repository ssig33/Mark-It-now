load 'deploy/assets'
require "bundler/capistrano"

set :application, "mark_it_now"
set :repository, "gitosis@ssig33.com:mark_it_now.git"

set :unicorn_pid ,"/home/ssig33/deploy/pid/mark_it_now.pid"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "ssig33.com"
set :branch,      'master'

set :deploy_to,   "/home/ssig33/deploy/mark_it_now"
set :user, "ssig33"

namespace :deploy do
  task :restart do
    run "cd #{current_path} && bundle exec rake db:migrate RAILS_ENV=production"
    run "cd #{current_path} && ln -s /home/ssig33/drobo/share/Book /home/ssig33/deploy/mark_it_now/current/data && ln -s ~/deploy/groonga/mark_it_now db/groonga"
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end
end

task :start do
  run "cd #{current_path} && BUNDLE_GEMFILE=#{current_path}/Gemfile && bundle exec unicorn -c unicorn.conf -D -E production"
  
end

task :reload do
  run "kill -s USR2 `cat #{unicorn_pid}`"
end

task :stop do
  run "kill -s QUIT `cat #{unicorn_pid}`"
end

task :setup do
  run "cd #{current_path} && bundle && bundle exec rake db:migrate RAILS_ENV=production  && bundle exec rake assets:precompile&& mkdir public/data"
end

