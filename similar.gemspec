# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "similar/version"

Gem::Specification.new do |s|
  s.name        = "similar"
  s.version     = Similar::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Fabio Yamate"]
  s.email       = ["fabioyamate@gmail.com"]
  s.homepage    = "http://github.com/fabioyamate/similar"
  s.summary     = %q{Simple similarity and recomendation solution for Rails}
  s.description = %q{Simple similarity and recomendation solution for Rails}

  s.rubyforge_project = "similar"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
