#!/usr/bin/env puma

basedir = '/home/deploy/apps/CrjCom/current'

# Change to match your CPU core count
workers 4

# Min and Max threads per worker
threads 1, 6

app_dir = File.expand_path("../..", __FILE__)
# app_dir = "/home/deploy/apps/CrjCom/current"
shared_dir = "#{app_dir}/shared"

# Default to production
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

# Setp up socket location
bind "unix://#{shared_dir}/tmp/sockets/CrjCom-puma.sock"

# Logging
# stdout_redirect "#{}/log/puma.stdout.log", "#{release_path}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{shared_path}/tmp/pids/puma.pid"
state_path "#{shared_path}/tmp/pids/puma.state"

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end