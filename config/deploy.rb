# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock "~> 3.17.0"

set :application, "diverse"
set :repo_url, "git@github.com:woodpecker-jp/diverse.git"
set :user, "ec2-user"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"
# set :deploy_to, "/var/www/#{fetch(:user)}/apps/#{fetch(:application)}"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

set :rbenv_ruby, "3.0.1"

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"
append :linked_files, "config/master.key"
append :linked_files, ".env"
append :linked_files, "firebase_key.json"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/logs", "node_modules", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :deploy do
  namespace :check do
    # upload your local master.key in case it's missing on the deploy target
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        upload! "config/master.key", "#{shared_path}/config/master.key" unless test("[ -f #{shared_path}/config/master.key ]")
      end
    end

    # upload your local .env in case it's missing on the deploy target
    before :linked_files, :set_environment_variables do
      on roles(:app), in: :sequence, wait: 10 do
        upload! ".env", "#{shared_path}/.env" unless test("[ -f #{shared_path}/.env ]")
      end
    end

    # upload your local .env in case it's missing on the deploy target
    before :linked_files, :set_firebase_key do
      on roles(:app), in: :sequence, wait: 10 do
        upload! "firebase_key.json", "#{shared_path}/firebase_key.json" unless test("[ -f #{shared_path}/firebase_key.json ]")
      end
    end
  end

  task :restart do
    on roles(:app) do
      invoke "unicorn:restart"
    end
  end

  task :yarn_install do
    on roles(:all) do
      within release_path do
        execute :yarn, :install
      end
    end
  end

  before "deploy:updated", "deploy:yarn_install"
  after "deploy:publishing", "deploy:restart"
end
