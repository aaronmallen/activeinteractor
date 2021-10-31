# frozen_string_literal: true

require_relative 'lib/active_interactor/version'

Gem::Specification.new do |spec|
  repo = 'https://github.com/aaronmallen/activeinteractor'
  gem_version = ActiveInteractor::Version.gem_version.freeze
  semver = ActiveInteractor::Version.semver.freeze

  spec.platform      = Gem::Platform::RUBY
  spec.name          = 'activeinteractor'
  spec.version       = gem_version
  spec.summary       = 'Ruby interactors with ActiveModel::Validations'
  spec.description   = <<~DESC
    An implementation of the Command Pattern for Ruby with ActiveModel::Validations inspired by the interactor gem.
    Rich support for attributes, callbacks, and validations, and thread safe performance methods.
  DESC

  spec.required_ruby_version = '>= 2.5.0'

  spec.license       = 'MIT'

  spec.authors       = ['Aaron Allen']
  spec.email         = ['hello@aaronmallen.me']
  spec.homepage      = repo

  spec.files         = Dir['CHANGELOG.md', 'LICENSE', 'README.md', 'lib/**/*']
  spec.require_paths = ['lib']
  spec.test_files    = Dir['spec/**/*']

  spec.metadata = {
    'bug_tracker_uri' => "#{repo}/issues",
    'changelog_uri' => "#{repo}/blob/v#{semver}/CHANGELOG.md",
    'documentation_uri' => "https://www.rubydoc.info/gems/activeinteractor/#{gem_version}",
    'hompage_uri' => spec.homepage,
    'source_code_uri' => "#{repo}/tree/v#{semver}",
    'wiki_uri' => "#{repo}/wiki"
  }

  spec.add_dependency 'activemodel', '>= 4.2', '< 7'
  spec.add_dependency 'activesupport', '>= 4.2', '< 7'
end
