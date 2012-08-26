# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fortune_teller/version"

Gem::Specification.new do |s|
  s.name        = "fortune_teller"
  s.version     = FortuneTeller::VERSION
  s.authors     = ["JayTeeSr"]
  s.email       = ["jaytee_sr_at_his-service_dot_net"]
  s.homepage    = "https://github.com/JayTeeSF/fortune_teller"
  s.summary     = %q{Commandline Ruby version of an origami fortune teller: http://en.wikipedia.org/wiki/Paper_fortune_teller}
  s.description = %q{Commandline Ruby version of an origami fortune teller: http://en.wikipedia.org/wiki/Paper_fortune_teller}
  s.rubyforge_project = "fortune_teller"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.bindir        = 'bin'
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('rubygame', '>= 2.6.4')
  # specify any dependencies here; for example:
  s.add_development_dependency "rspec", "~> 2.11.0"
  #s.add_development_dependency "ruby-debug19"
end
