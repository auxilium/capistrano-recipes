server "your-server.com", :web, :app, :db, :primary => true

set :domain,                    "staging.your-application.org"
set :deploy_to,                 "/home/#{user}/apps/#{application}"
set :unicorn_workers,           3
