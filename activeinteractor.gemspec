# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_interactor/version'

version = ActiveInteractor::VERSION.dup

Gem::Specification.new do |spec|
  spec.platform      = Gem::Platform::RUBY
  spec.name          = 'activeinteractor'
  spec.version       = version
  spec.summary       = 'Ruby interactors with ActiveModel::Validations'
  spec.description   = <<~DESC
    An implementation of the Command Pattern for Ruby with ActiveModel::Validations inspired by the interactor gem.
    Rich support for attributes, callbacks, and validations, and thread safe performance methods.
  DESC

  spec.required_ruby_version = '>= 2.5.0'

  spec.license       = 'MIT'

  spec.authors       = ['Aaron Allen']
  spec.email         = ['hello@aaronmallen.me']
  spec.homepage      = 'https://github.com/aaronmallen/activeinteractor'

  spec.files         = Dir['.yardopts', 'CHANGELOG.md', 'LICENSE', 'README.md', 'lib/**/*']
  spec.require_paths = ['lib']
  spec.test_files    = Dir['spec/**/*']

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/aaronmallen/activeinteractor/issues',
    'changelog_uri' => "https://github.com/aaronmallen/activeinteractor/blob/v#{version}/CHANGELOG.md",
    'documentation_uri' => "https://www.rubydoc.info/gems/activeinteractor/#{version}",
    'hompage_uri' => spec.homepage,
    'source_code_uri' => "https://github.com/aaronmallen/activeinteractor/tree/v#{version}",
    'wiki_uri' => 'https://github.com/aaronmallen/activeinteractor/wiki'
  }

  spec.add_dependency 'activemodel', '>= 4.2', '< 7.0'
  spec.add_dependency 'activesupport', '>= 4.2', '< 7.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.9'
end
