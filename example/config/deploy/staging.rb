server "your-server.com", :web, :app, :db, :primary => true

set :include_www_alias,         false
set :domain,                    "staging.your-application.org"
set :deploy_to,                 "/home/#{user}/apps/#{application}_staging"
