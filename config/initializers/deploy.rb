# set :linked_files, fetch(:linked_files, []).push("config/master.key")
set :application, "sample_rails_app"
set :repo_url, "https://github.com/JetBrains/sample_rails_app"
set :branch, "capistrano-deploy"
set :deploy_to, "/home/deploy/#{fetch :application}"
set :passenger_restart_with_touch, true 
append :linked_files, "config/master.key"
