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

role :web, "giankavh"                          # Your HTTP server, Apache/etc
role :app, "giankavh"                          # This may be the same as your `Web` server
role :db,  "giankavh", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end
