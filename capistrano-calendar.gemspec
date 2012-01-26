# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "capistrano/calendar/version"

Gem::Specification.new do |s|
  s.name        = "capistrano-calendar"
  s.version     = Capistrano::Calendar::VERSION
  s.authors     = ["Andriy Yanko"]
  s.email       = ["andriy.yanko@gmail.com"]
  s.homepage    = "https://github.com/railsware/capistrano-calendar/"
  s.summary     = %q{Deployment event creation on (google) calendar service}

  s.rubyforge_project = "capistrano-calendar"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "capistrano", ">=2.5.5"
  s.add_runtime_dependency "gdata_19",      ">=1.1.0"
  s.add_runtime_dependency "json"
end
