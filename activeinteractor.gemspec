# frozen_string_literal: true

require_relative 'lib/active_interactor/version'

Gem::Specification.new do |spec|
  spec.platform      = Gem::Platform::RUBY
  spec.name          = 'activeinteractor'
  spec.version       = ActiveInteractor::Version.gem_version
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

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/aaronmallen/activeinteractor/issues',
    'changelog_uri' =>
      "https://github.com/aaronmallen/activeinteractor/blob/v#{ActiveInteractor::Version.semver}/CHANGELOG.md",
    'documentation_uri' => "https://www.rubydoc.info/gems/activeinteractor/#{ActiveInteractor::Version.gem_version}",
    'hompage_uri' => spec.homepage,
    'source_code_uri' => "https://github.com/aaronmallen/activeinteractor/tree/v#{ActiveInteractor::Version.semver}",
    'wiki_uri' => 'https://github.com/aaronmallen/activeinteractor/wiki'
  }

  spec.add_dependency 'activemodel', '>= 4.2', '< 9'
  spec.add_dependency 'activesupport', '>= 4.2', '< 9'

  spec.add_development_dependency 'bundler', '~> 2.3'
end
