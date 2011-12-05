# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "morpheus/version"

Gem::Specification.new do |s|
  s.name        = "morpheus"
  s.version     = Morpheus::VERSION
  s.authors     = ["Dmytrii Nagirniak"]
  s.email       = ["dnagir@gmail.com"]
  s.homepage    = "https://github.com/dnagir/morpheus"
  s.summary     = %q{Rubysh neo4j REST API for Rails or as standalone library.}
  s.description = %q{Model your application in Ruby, persist and query with neo4j graph database.}

  s.rubyforge_project = "morpheus"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'activesupport', '>= 3.1'
  s.add_dependency 'activemodel', '>= 3.1'
  s.add_dependency 'multi_json'
  s.add_dependency 'recursive-open-struct'

  s.add_development_dependency "rspec"
  s.add_development_dependency "guard"
  s.add_development_dependency "fakeweb"

  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "ruby_gntp"
  s.add_development_dependency "pry"
  # s.add_runtime_dependency "rest-client"
end
