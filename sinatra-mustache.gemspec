# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sinatra-mustache/version"

Gem::Specification.new do |s|
  s.name        = "sinatra-mustache"
  s.version     = Sinatra::Mustache::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Jason Campbell', 'Beat Richartz']
  s.email       = ['attraccessor@gmail.com']
  s.homepage    = 'http://github.com/beatrichartz/sinatra-mustache'
  s.summary     = %q{Use Mustache in your Sinatra app without the extra view classes}
  s.description = %q{Use Mustache in your Sinatra app without the extra view classes}

  s.rubyforge_project = "sinatra-mustache"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'sinatra', '~> 1'
  s.add_dependency 'mustache', '~> 0.99'
  s.add_dependency 'tilt', '~> 1.2', '~> 1.3'

  s.add_development_dependency 'rspec', '~> 2'
  s.add_development_dependency 'rack-test', '~> 0'
end
