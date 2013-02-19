# -*- encoding: utf-8 -*-
require File.expand_path('../lib/capistrano-recipes/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "capistrano-recipes"
  gem.version       = CapistranoRecipes::VERSION
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
