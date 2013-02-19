require File.expand_path(File.dirname(__FILE__) + '/../helpers')

Capistrano::Configuration.instance.load do
  set_default(:unicorn_user)    { user }
  set_default(:unicorn_pid)     { "#{shared_path}/pids/unicorn.pid" }
  set_default(:unicorn_sock)    { "/tmp/unicorn.#{application}_#{stage}.sock" }
  set_default(:unicorn_config)  { "#{shared_path}/config/unicorn.rb" }
  set_default(:unicorn_log)     { "#{shared_path}/log/unicorn.log" }
  set_default(:unicorn_workers) { 2 }
  set_default(:unicorn_timeout) { 30 }

  after "deploy:setup",     "unicorn:setup"
  after "deploy:restart",   "unicorn:upgrade"
  after "deploy:start",     "unicorn:start"
  after "deploy:stop",      "unicorn:stop"

  namespace :unicorn do
    desc "Set up Unicorn initializer and app configuration"
    task :setup, roles: :app do
      run "mkdir -p #{shared_path}/config"
      template "unicorn.rb.erb", unicorn_config
      template "unicorn_init.erb", "/tmp/unicorn_init"
      run "chmod +x /tmp/unicorn_init"
      run "#{sudo} mv /tmp/unicorn_init /etc/init.d/unicorn_#{application}_#{stage}"
      run "#{sudo} update-rc.d -f unicorn_#{application}_#{stage} defaults"
    end

    %w{start stop restart upgrade}.each do |command|
      desc "#{command} unicorn"
      task command, roles: :app do
        run "/etc/init.d/unicorn_#{application}_#{stage} #{command}"
      end
    end
  end
end
