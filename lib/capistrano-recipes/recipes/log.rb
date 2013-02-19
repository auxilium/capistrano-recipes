Capistrano::Configuration.instance.load do
  namespace :log do
    def tail file
      trap("INT") { puts 'Interupted'; exit 0; }
      run "tail -f #{file}" do |channel, stream, data|
        puts "#{channel[:host]}: #{data}"
        break if stream == :err
      end
    end

    desc "tails the rails log as default"
    task :default, :roles => :app do
      rails
    end

    desc "tails the rails log"
    task :rails, :roles => :app do
      tail "#{shared_path}/log/#{rails_env}.log"
    end

    if exists?(:sidekiq_cmd)
      desc "tails the SideKiq log"
      task :sidekiq, :roles => :app do
        tail "#{shared_path}/log/sidekiq.log"
      end
    end

    desc "tails the Unicorn log"
    task :unicorn, :roles => :app do
      tail "#{shared_path}/log/unicorn.log"
    end
  end
end
