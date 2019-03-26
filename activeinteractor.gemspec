# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_interactor/version'

version = ActiveInteractor::VERSION.dup

Gem::Specification.new do |spec|
  spec.platform      = Gem::Platform::RUBY
  spec.name          = 'activeinteractor'
  spec.version       = version
  spec.summary       = 'Ruby interactors based on ActiveModel'
  spec.description   = 'Ruby interactors based on ActiveModel'

  spec.required_ruby_version = '>= 2.5.0'

  spec.license       = 'MIT'

  spec.authors       = ['Aaron Allen']
  spec.email         = ['hello@aaronmallen.me']
  spec.homepage      = 'https://github.com/aaronmallen/activeinteractor'

  spec.files         = Dir['CHANGELOG.md', 'LICENSE', 'README.md', 'lib/**/*']
  spec.require_paths = ['lib']

  spec.metadata = {
    'hompage_uri' => spec.homepage,
    'source_code_uri' => "https://github.com/aaronmallen/activeinteractor/tree/v#{version}",
    'changelog_uri' => "https://github.com/aaronmallen/activeinteractor/blob/v#{version}/CHANGELOG.md"
  }

  spec.add_dependency 'activemodel', '>= 4.2', '< 6.1'
  spec.add_dependency 'activesupport', '>= 4.2', '< 6.1'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'github-markup', '~> 3.0'
  spec.add_development_dependency 'mdl', '~> 0.5'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'redcarpet', '~> 3.4'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.66'
  spec.add_development_dependency 'simplecov', '~> 0.16'
  spec.add_development_dependency 'yard', '~> 0.9'
  spec.add_development_dependency 'yard-activesupport-concern', '0.0.1'
end
