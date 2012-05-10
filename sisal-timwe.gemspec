# -*- encoding: utf-8 -*-
require File.expand_path("../lib/sisal-timwe/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Vinicius Horewicz"]
  gem.email         = ["vinicius@horewi.cz"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "sisal-timwe"
  gem.require_paths = ["lib"]
  gem.version       = Sisal::Timwe::VERSION

  # gem.add_dependency "sisal",       "~> 0.0"
  gem.add_dependency "rest-client", "~> 1.6"

  gem.add_development_dependency "rspec",   "~> 2.8"
  gem.add_development_dependency "webmock", "~> 1.7"
end
