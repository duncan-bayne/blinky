# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blinky/version'

Gem::Specification.new do |gem|
  gem.name          = "blinky"
  gem.version       = Blinky::VERSION
  gem.summary = %q{helps you see the light}
  gem.authors       = ["Perryn Fowler"]
  gem.email         = ["perryn.fowler@gmail.com"]
  gem.description   = %q{plug and play support for USB build status indicators}
  gem.homepage      = "http://github.com/perryn/blinky"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "libusb", "~> 0.6.3"
  gem.add_dependency "chicanery", "~> 0.1.8"

  gem.add_development_dependency "rake", "~> 12.3.1"
  gem.add_development_dependency "rspec", "~> 3.7.0"
end
