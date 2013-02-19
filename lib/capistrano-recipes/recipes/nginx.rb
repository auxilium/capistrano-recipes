require 'capistrano/ext/multistage'
require 'capistrano-recipes/helpers'

Capistrano::Configuration.instance(true).load do
  set_default(:include_www_alias)    { true }

  namespace :nginx do
    desc "Setup nginx config for the application"
    task :setup, roles: :web do
      template "nginx_unicorn.erb", "/tmp/nginx_conf"
      run "#{sudo} mv /tmp/nginx_conf /etc/nginx/conf.d/#{application}_#{stage}.conf"
      restart
    end
    after "deploy:setup", "nginx:setup"

    %w{start stop restart}.each do |command|
      desc "#{command} nginx"
      task command, roles: :web do
        run "#{sudo} service nginx #{command}"
      end
    end
  end
end
