# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'project/omaha/version'

Gem::Specification.new do |spec|
  spec.name          = 'project-omaha'
  spec.version       = Project::Omaha::VERSION
  spec.authors       = ['Mobility Labs']
  spec.email         = ['sean@mobility-labs.com']

  spec.summary       = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.homepage      = 'http//www.mobility-labs.com'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Development dependencies
  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'

  # Runtime dependencies
  spec.add_runtime_dependency 'acts_as_commentable_with_threading', '~> 2.0.1'
end