# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "domodoro/version"

Gem::Specification.new do |s|
  s.name        = "domodoro"
  s.version     = Domodoro::VERSION
  s.authors     = ["Josep M. Bach"]
  s.email       = ["josep.m.bach@gmail.com"]
  s.homepage    = "http://github.com/txus/domodoro"
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "domodoro"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'eventmachine'
  s.add_development_dependency 'minitest'
end
