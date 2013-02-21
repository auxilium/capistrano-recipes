require File.expand_path(File.dirname(__FILE__) + '/../helpers')

Capistrano::Configuration.instance.load do
  namespace :log do
    desc "tails the rails log as default"
    task :default, :roles => :app do
      rails
    end

    desc "tails the rails log"
    task :rails, :roles => :app do
      trap("INT") { puts 'Interupted'; exit 0; }
      stream "tail -f #{shared_path}/log/#{rails_env}.log"
    end

    if exists?(:sidekiq_cmd)
      desc "tails the SideKiq log"
      task :sidekiq, :roles => :app do
        trap("INT") { puts 'Interupted'; exit 0; }
        stream "tail -f #{shared_path}/log/sidekiq.log"
      end
    end

    desc "tails the Unicorn log"
    task :unicorn, :roles => :app do
      trap("INT") { puts 'Interupted'; exit 0; }
      stream "tail -f #{shared_path}/log/unicorn.log"
    end
  end
end
