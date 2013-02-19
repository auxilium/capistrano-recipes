# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano-recipes/version'

Gem::Specification.new do |gem|
  gem.name          = "capistrano-recipes"
  gem.version       = Capistrano::Recipes::VERSION
  gem.authors       = ["Manuel van Rijn"]
  gem.email         = ["manuel@auxilium.nl"]
  gem.description   = %q{Some handy recipes we use for our projects}
  gem.summary       = %q{Capistrano Recipes}
  gem.homepage      = "http://www.auxilium.nl"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "capistrano", ">= 2.13.5"
  gem.add_development_dependency "rake"
end
