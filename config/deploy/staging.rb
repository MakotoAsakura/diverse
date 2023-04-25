# frozen_string_literal: true

set :branch, ENV.fetch("BRANCH", "develop")
set :rails_env, "staging"
set :unicorn_env, :staging
set :unicorn_rack_env, "staging"
set :deploy_to, "/var/www/#{fetch(:application)}"
set :ssh_options, {
  forward_agent: true,
  auth_methods: %w[publickey]
}
server "18.178.97.21",
       user: "ubuntu",
       roles: %w[web app db],
       keys: %w[~/.ssh/pem/diverse_sample_hungdt]
