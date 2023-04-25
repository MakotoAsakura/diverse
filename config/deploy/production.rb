# frozen_string_literal: true

set :branch, ENV.fetch("BRANCH", "develop")
set :rails_env, "production"
set :unicorn_env, :production
set :unicorn_rack_env, "production"
set :deploy_to, "/var/www/#{fetch(:application)}"
set :ssh_options, {
  forward_agent: true,
  auth_methods: %w[publickey]
}
server "18.176.26.145",
       user: "ubuntu",
       roles: %w[web app db],
       keys: %w[~/.ssh/pem/diverse_production]
