require File.expand_path(File.dirname(__FILE__) + '/../helpers')

Capistrano::Configuration.instance.load do
  set_default(:include_www_alias)    { true }

  after "deploy:setup", "nginx:setup"

  namespace :nginx do
    desc "Setup nginx config for the application"
    task :setup, roles: :web do
      template "nginx_unicorn.erb", "/tmp/nginx_conf"
      run "#{sudo} mv /tmp/nginx_conf /etc/nginx/conf.d/#{application}_#{stage}.conf"
      restart
    end

    %w{start stop restart}.each do |command|
      desc "#{command} nginx"
      task command, roles: :web do
        run "#{sudo} service nginx #{command}"
      end
    end
  end
end
