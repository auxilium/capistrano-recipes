require 'erb'
require 'yaml'

require 'capistrano'
require 'capistrano/ext/multistage'

# Helper Methods
def template(from, to)
  erb = File.read(File.expand_path("../recipes/templates/#{from}", __FILE__))
  put ERB.new(erb, nil, '-').result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end
