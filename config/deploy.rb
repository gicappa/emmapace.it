require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :application, "emmapace"
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
role :db,  "giankavh"

#$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.


set :rvm_ruby_string, 'ruby-1.9.2-p290'        # Or whatever env you want it to run in.
#set :rvm_type, :system  # Copy the exact line. I really mean :user here
#set :rvm_type, :user  # Copy the exact line. I really mean :user here

set :normalize_asset_timestamps, false

#default_run_options[:pty] = true

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

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

  desc "precompile the assets"
  task :precompile_assets, :roles => :web, :except => { :no_release => true } do
    run "cd #{current_path}; rm -rf public/assets/*"
    run "cd #{current_path}; RAILS_ENV=production /srv/www/.rvm/gems/ruby-1.9.2-p290/bin/bundle exec rake assets:precompile"
  end
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end

  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && bundle install --without test"
  end

  task :lock, :roles => :app do
    run "cd #{current_release} && bundle lock;"
  end

  task :unlock, :roles => :app do
    run "cd #{current_release} && bundle unlock;"
  end
end


after "deploy:update_code" do
  bundler.bundle_new_release
end

after "deploy", "deploy:cleanup"
