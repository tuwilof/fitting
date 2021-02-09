lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fitting/version'

Gem::Specification.new do |spec|
  spec.name          = 'fitting'
  spec.version       = Fitting::VERSION
  spec.authors       = ['d.efimov']
  spec.email         = ['d.efimov@fun-box.ru']

  spec.summary       = 'Coverage API Blueprint, Swagger and OpenAPI with rspec tests'
  spec.description   = 'Coverage API Blueprint, Swagger and OpenAPI with rspec tests for easily make high-quality'
  spec.homepage      = 'https://github.com/funbox/fitting'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'json-schema', '~> 2.6', '>= 2.6.2'
  spec.add_runtime_dependency 'multi_json', '~> 1.11'
  spec.add_runtime_dependency 'tomograph', '~> 3.0', '>= 3.1.0'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'byebug', '~> 8.2', '>= 8.2.1'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.4', '>= 3.4.0'
  spec.add_development_dependency 'rubocop', '~> 0.49.1', '>= 0.49.1'
  spec.add_development_dependency 'simplecov', '~> 0.11', '>= 0.11.2'
end
