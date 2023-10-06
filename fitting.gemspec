lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fitting/version'

Gem::Specification.new do |spec|
  spec.name          = 'fitting'
  spec.version       = Fitting::VERSION
  spec.authors       = ['d.efimov']
  spec.email         = ['d.efimov@fun-box.ru']

  spec.summary       = 'Coverage API Blueprint, Swagger and OpenAPI with RSpec'
  spec.description   = 'Coverage API Blueprint, Swagger and OpenAPI with RSpec for easily make high-quality API and documenatiton'
  spec.homepage      = 'https://github.com/matchtechnologies/fitting'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.5.0'
  spec.add_runtime_dependency 'json-schema', '~> 2.6', '>= 2.6.2'
  spec.add_runtime_dependency 'terminal-table', '~> 3.0', '>= 3.0.2'
  spec.add_runtime_dependency 'tomograph', '~> 3.1', '>= 3.1.5'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'byebug', '~> 11.1', '>= 11.1.3'
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.6'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'rubocop', '>= 1.22.0'
  spec.add_development_dependency 'simplecov', '~> 0.21'
end
