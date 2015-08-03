require File.expand_path(File.dirname(__FILE__) + '/../helpers')

Capistrano::Configuration.instance.load do
  set_default(:postgresql_create_user)  { Capistrano::CLI.ui.ask "Would you like to create a new postgres user? (Y/N)" }
  set_default(:postgresql_user)         { Capistrano::CLI.ui.ask "Enter #{stage} database username:" }
  set_default(:postgresql_password)     { Capistrano::CLI.password_prompt "Enter #{stage} database password:" }
  set_default(:postgresql_database)     { "#{application}_#{stage}" }
  set_default(:postgresql_pull_confirm) { Capistrano::CLI.ui.ask "WARNING!!!\nAre you sure you want to DROP and PULL the database from the #{stage} server???\n\n\nPlease enter the application and stage name to confirm (#{application}_#{stage})" }

  after "deploy:setup",             "postgresql:create_database"
  after "deploy:setup",             "postgresql:setup"
  after "deploy:finalize_update",   "postgresql:create_symlink"

  namespace :postgresql do
    desc "Create the database for this application"
    task :create_database, roles: :db, only: { primary: true } do
      if postgresql_create_user.downcase == "y"
        run %Q{#{sudo} -u postgres psql -c "create user #{postgresql_user} with password '#{postgresql_password}';"}
      end
      run %Q{#{sudo} -u postgres psql -c "create database #{postgresql_database} owner #{postgresql_user};"}
    end

    desc "Generate the database.yml config file"
    task :setup, roles: :app do
      run "mkdir -p #{shared_path}/config"
      template "postgresql.yml.erb", "#{shared_path}/config/database.yml"
    end

    desc "Symlink the database.yml file into latest release"
    task :create_symlink, roles: :app do
      run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    end

    desc "Pull the remote database to local"
    task :pull, roles: :db, only: { primary: true } do
      raise Capistrano::CommandError.new("WRONG application name") unless postgresql_pull_confirm.strip == "#{application}_#{stage}"

	  puts "if it doesn't work anymore, try reverting this https://github.com/auxilium/capistrano-recipes/blob/master/lib/capistrano-recipes/recipes/postgresql.rb to 81d02d0907b165236268014a38944d10b35acade. Good luck with that."
	  
      prod_config = capture "cat #{shared_path}/config/database.yml"
	  
	  prod = YAML::load(prod_config)["#{stage}"]

      dev  = YAML::load_file("config/database.yml")["development"]

      dump = "/tmp/#{Time.now.to_i}-#{application}_#{stage}.psql"
      # make sure you have configured the pg_hba.conf to allow md5 instead of peer for "local all all"
      run %{PGPASSWORD=#{prod["password"]} pg_dump --no-acl --ignore-version -Fc --username=#{prod["username"]} --file=#{dump} #{prod["database"]}}
      get dump, dump
      run "rm #{dump}"

      system %{dropdb -U #{dev["username"]} #{dev["database"]}}
      system %{createdb -U #{dev["username"]} #{dev["database"]} -O #{dev["username"]}}
      system %{pg_restore --no-owner --no-acl --schema=public --username=#{dev["username"]} --dbname=#{dev["database"]} #{dump}}
      system "rm #{dump}"
    end
  end
end
