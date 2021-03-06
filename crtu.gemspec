# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crtu/version'

Gem::Specification.new do |spec|
  spec.name          = "crtu"
  spec.version       = Crtu::VERSION
  spec.authors       = ["Fábio André Ramos Rodrigues"]
  spec.email         = ["fabio_rodrigues@student-partners.com"]

  spec.summary       = %q{Cucumber Ruby Test Utilities}
  spec.description   = %q{Useful Cucumber and ruby test utilities,like loggers, rake tasks, etc...}
  spec.homepage      = "https://github.com/Th33x1l3/CRTU"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_runtime_dependency 'log4r', '~> 1.1', '>= 1.1.10'
  spec.add_runtime_dependency 'cucumber', '~> 2.3', '> 2.3.0'

end
