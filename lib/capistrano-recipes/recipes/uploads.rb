require File.expand_path(File.dirname(__FILE__) + '/../helpers')

Capistrano::Configuration.instance.load do
  set_default(:upload_path) { "#{shared_path}/uploads" }

  after "deploy:setup",             "uploads:setup"
  after "deploy:create_symlink",    "uploads:create_symlink"

  namespace :uploads do
    desc "Creates a shared folder for Uploads"
    task :setup, roles: :web do
      run "mkdir -p #{upload_path}"
    end

    desc "Symlinks the uploads to the current public folder"
    task :create_symlink, roles: :web do
      run "ln -nfs #{upload_path} #{current_path}/public/"
    end
  end
end
