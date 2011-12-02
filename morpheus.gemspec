# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "morpheus/version"

Gem::Specification.new do |s|
  s.name        = "morpheus"
  s.version     = Morpheus::VERSION
  s.authors     = ["Dmytrii Nagirniak"]
  s.email       = ["dnagir@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Easy to use neo4j REST API in Rails or as standalone library.}
  s.description = %q{Model your application in Ruby, persist to the neo4j graph database.}

  s.rubyforge_project = "morpheus"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
