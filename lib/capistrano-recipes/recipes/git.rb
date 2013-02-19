Capistrano::Configuration.instance(true).load do
  namespace :git do
    desc "Make sure local git is in sync with remote."
    task :check_revision, roles: :web do
      unless `git rev-parse HEAD` == `git rev-parse origin/#{branch}`
        puts "WARNING: HEAD is not the same as origin/#{branch}"
        puts "Run `git push` to sync changes."
        exit
      end
    end
    before "deploy", "git:check_revision"
    before "deploy:migrations", "git:check_revision"
    before "deploy:cold", "git:check_revision"
  end
end
