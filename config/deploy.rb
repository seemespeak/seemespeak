require 'torquebox-capistrano-support'
require 'bundler/capistrano'

# SCM
set :application,       "seemespeak"
set :repository,        "https://github.com/railsrumble/r13-team-39.git"
set :user,              "railsrumble"
set :scm,               :git
set :scm_verbose,       true
set :use_sudo,          false

# Production server
set :deploy_to,         "/home/railsrumble/seemespeak"
set :torquebox_home,    "/home/railsrumble/torquebox-3.0.0"
set :rails_env,         "production"
set :app_context,       "/"

ssh_options[:forward_agent] = false

role :web,  "rumble.seemespeak.org", :primary => true 

set :config_files, ['admin_settings.yml']

namespace :deploy do
  task :symlink_config, roles: :web do
    config_files.each do |filename|
      run "cp #{shared_path}/config/#{filename} #{release_path}/config/#{filename}"
    end
  end
  after "deploy:finalize_update", "deploy:symlink_config"
end
