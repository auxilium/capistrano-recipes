require 'capistrano'
require 'capistrano/cli'

require 'capistrano-recipes/helpers'

Dir.glob(File.join(File.dirname(__FILE__), '/capistrano-recipes/recipes/*.rb')).sort.each { |f| load f }
