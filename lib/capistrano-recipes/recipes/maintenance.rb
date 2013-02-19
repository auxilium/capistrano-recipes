require 'capistrano-recipes/helpers'

Capistrano::Configuration.instance.load do
  set_default(:maintenance_path) { "#{shared_path}/system/maintenance" }

  namespace :maintenance do
    before "maintenance:on", "maintenance:check_maintenance_present"
    after "deploy:update_code", "maintenance:update_maintenance_page"

    task :on, :roles => :web do
      on_rollback { run "mv #{maintenance_path}/index.html #{maintenance_path}/index.disabled.html" }
      run "mv #{maintenance_path}/index.disabled.html #{maintenance_path}/index.html"
    end

    task :off, :roles => :web do
      run "mv #{maintenance_path}/index.html #{maintenance_path}/index.disabled.html"
    end

    desc "Copies your maintenance from public/maintenance to shared/system/maintenance."
    task :update_maintenance_page, :roles => :web do
      new_maintenance_path = "#{release_path}/public/maintenance"
      run "cp -r #{new_maintenance_path} /tmp/#{application}_maintenance"

      # check if first time we deploy, if so we disable the maintenance page
      # or if we are not in maintenance mode, we want to keep it that way
      if remote_file_exists?("#{maintenance_path}/") == false or remote_file_exists?("#{maintenance_path}/index.disabled.html")
        run "mv /tmp/#{application}_maintenance/index.html /tmp/#{application}_maintenance/index.disabled.html"
      end

      run "rm -rf #{maintenance_path}; true"
      run "cp -r /tmp/#{application}_maintenance #{maintenance_path}"
      run "rm -rf /tmp/#{application}_maintenance; true"
    end

    task :check_maintenance_present, :roles => :web do
      maintenance_file = File.expand_path("../../../public/maintenance/index.html", __FILE__)
      unless File.exist?(maintenance_file)
        error = CommandError.new("Can't find /public/maintenance/index.html. Please create it first")
        raise error
      end
    end
  end
end
