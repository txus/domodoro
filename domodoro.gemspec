# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "domodoro/version"

Gem::Specification.new do |s|
  s.name        = "domodoro"
  s.version     = Domodoro::VERSION
  s.authors     = ["Josep M. Bach"]
  s.email       = ["josep.m.bach@gmail.com"]
  s.homepage    = "http://github.com/txus/domodoro"
  s.summary     = %q{Distributed Pomodoro for the masses}
  s.description = %q{Distributed Pomodoro for the masses}

  s.rubyforge_project = "domodoro"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'eventmachine'
  s.add_runtime_dependency 'notify'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'purdytest'
end
