# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tabloid/version"

Gem::Specification.new do |s|
  s.name        = "tabloid"
  s.version     = Tabloid::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Keith Gaddis"]
  s.email       = ["keith.gaddis@gmail.com"]
  s.homepage    = "http://github.com/karmajunkie/tabloid"
  s.summary     = %q{ Tabloid allows the creation of cacheable report data using a straightforward DSL and output to HTML, CSV, and more to come.}
  s.description = %q{ Tabloid allows the creation of cacheable report data using a straightforward DSL and output to HTML, CSV, and more to come.}

  s.rubyforge_project = "tabloid"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_development_dependency "rspec"
  s.add_development_dependency "nokogiri"
  s.add_development_dependency "activerecord", ">=3.0"
  s.add_development_dependency "sqlite3"
  s.add_runtime_dependency "virtus", '~>1.0.3'
  s.add_runtime_dependency "builder"
end
