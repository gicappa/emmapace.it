require "rvm/capistrano"                  # Load RVM's capistrano plugin.

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.

set :application, "emmapace.it"
set :repository,  "git@github.com:gicappa/emmapace.it.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user, "www-data"
set :branch, "master"
set :scm_verbose, true

#set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :deploy_to, "/srv/www/emmapace.it/htdocs"

set :use_sudo, false
set :rvm_ruby_string, 'ruby-1.9.2-p290'        # Or whatever env you want it to run in.
#set :rvm_type, :system  # Copy the exact line. I really mean :user here
#set :rvm_type, :user  # Copy the exact line. I really mean :user here

set :normalize_asset_timestamps, false

role :web, "giankavh"                          # Your HTTP server, Apache/etc
role :app, "giankavh"                          # This may be the same as your `Web` server
role :db,  "giankavh", :primary => true # This is where Rails migrations will run


# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end

   desc "Installs required gems"
   task :gems, :roles => :app do
     run "cd #{current_path} && rake gems:install RAILS_ENV=production"
   end

   after "deploy:setup", "deploy:gems"
   before "deploy", "deploy:web:disable"
   after "deploy", "deploy:web:enable"
 end
