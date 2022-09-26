# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog],
and this project adheres to [Semantic Versioning].

## [Unreleased]

## [v1.2.1] - 2022-09-26

### Fixed

- [\#358] Typo in generator template name

## [v1.1.7] - 2022-09-26

### Fixed

- [\#358] Typo in generator template name

## [v1.2.0] - 2022-09-08

### Added

- `ActiveInteractor::Base.defer_after_callbacks_when_organized`
- `ActiveInteractor::Organizer::Base.after_all_perform`
- `ActiveInteractor::Organizer::Base.around_all_perform`
- `ActiveInteractor::Organizer::Base.before_all_perform`

## [v1.1.6] - 2022-04-25

### Changed

- [\#344] Bump activemodel and activesupport to v7.0.2.3

## [v1.1.4] - 2022-03-07

### Changed

- [\#340] Bump activemodel and activesupport to 6.1.4.6

## [v1.1.3] - 2022-02-16

### Changed

- [\#338] Bump activemodel and activesupport to 6.1.4.4

## [v1.1.2] - 2020-11-10

### Changed

- [\#300](https://github.com/aaronmallen/activeinteractor/pull/300) `ActiveModel` and `ActiveSupport` v6.1 will be the
  highest supported version for `ActiveInteractor` v1.1.x

### Fixed

- [\#300](https://github.com/aaronmallen/activeinteractor/pull/300) `ActiveInteractor::Context::Error` compatibility
  with `ActiveModel` v6.1

## [v1.1.1] - 2020-10-21

### Fixed

- [\#267](https://github.com/aaronmallen/activeinteractor/pull/267) Allow default attributes to propagate to
  sibling/child interactors

## [v1.1.0] - 2020-10-04

### Added

- [\#247](https://github.com/aaronmallen/activeinteractor/issues/247) Support in place callbacks

### Fixed

- [\#242](https://github.com/aaronmallen/activeinteractor/issues/242) Optional attributes are always null
- [\#243](https://github.com/aaronmallen/activeinteractor/issues/243) Nested Organizers do not rollback parent context

## [v1.0.5] - 2020-09-15

### Fixed

- [\#200](https://github.com/aaronmallen/activeinteractor/issues/200) Context attributes assigned in interactor not
  accessible as element within interactor

## [v1.0.4] - 2020-02-11

### Fixed

- [\#184](https://github.com/aaronmallen/activeinteractor/issues/184) `ActiveInteractor::Context::Base#fail!` error

## [v1.0.3] - 2020-02-10

### Added

- `ActiveInteractor::Context::Errors`
- `ActiveInteractor::Context::Status#resolve`

### Fixed

- [\#168](https://github.com/aaronmallen/activeinteractor/issues/168) `#classify` is called on const arguments
- [\#169](https://github.com/aaronmallen/activeinteractor/issues/169) If some of the interactors of the organizer fail
  error message is not persisted.

## [v1.0.2] - 2020-02-04

### Added

- Support for `Dynamoid` ORM
- Support for `Mongoid` ORM

### Changed

- `ActiveInteractor::Models#acts_as_context` no longer includes `ActiveModel::Validations`
- `ActiveInteractor::Models#acts_as_context` now includes `ActiveInteractor::Context::Attributes`

### Removed

- `ActiveInteractor::Models::InstanceMethods#merge!`

## [v1.0.1] - 2020-01-28

### Added

- `ActiveInteractor::Context::Attributes#attribute?`
- `ActiveInteractor::Context::Attributes#has_attribute?`
- `ActiveInteractor::Context::Base.attribute`
- `ActiveInteractor::Context::Base.attribute_missing`
- `ActiveInteractor::Context::Base.attribute_names`
- `ActiveInteractor::Context::Base.method_missing`
- `ActiveInteractor::Context::Base.respond_to?`
- `ActiveInteractor::Context::Base.respond_to_without_attributes?`
- `ActiveInteractor::Context::Base#attribute_missing`
- `ActiveInteractor::Context::Base#attribute_names`
- `ActiveInteractor::Context::Base#method_missing`
- `ActiveInteractor::Context::Base#respond_to?`
- `ActiveInteractor::Context::Base#respond_to_without_attributes?`
- `ActiveInteractor::Interactor::Context#context_attribute_missing`
- `ActiveInteractor::Interactor::Context#context_attribute_names`
- `ActiveInteractor::Interactor::Context#context_respond_to_without_attributes?`
- `ActiveInteractor::Interactor::Context::ClassMethods#context_attribute`
- `ActiveInteractor::Interactor::Context::ClassMethods#context_attribute_missing`
- `ActiveInteractor::Interactor::Context::ClassMethods#context_attribute_names`
- `ActiveInteractor::Interactor::Context::ClassMethods#context_respond_to_without_attributes?`

## [v1.0.0] - 2020-01-26

### Added

- `ActiveInteractor::Config`
- `ActiveInteractor::Configurable`
- `ActiveInteractor::Context::Attributes#merge!`
- `ActiveInteractor::Context::Base#merge`
- `ActiveInteractor::Context::Loader`
- `ActiveInteractor::Context::Status`
- `ActiveInteractor::Error::InvalidContextClass`
- `ActiveInteractor::Models`
- `ActiveInteractor::Organizer::Callbacks`
- `ActiveInteractor::Organizer::InteractorInterface`
- `ActiveInteractor::Organizer::InteractorInterfaceCollection`
- `ActiveInteractor::Organizer::Organize`
- `ActiveInteractor::Organizer::Perform`
- `ActiveInteractor::Interactor::Context.contextualize_with`
- `ActiveInteractor::Interactor::Context#context_fail!`
- `ActiveInteractor::Interactor::Context#context_rollback!`
- `ActiveInteractor::Interactor::Context#finalize_context!`
- `ActiveInteractor::Interactor::Perform`
- `ActiveInteractor::Interactor::Perform::Options`
- `ActiveInteractor::Rails`
- `ActiveInteractor::Rails::Railtie`

### Changed

- `ActiveInteractor::Base` now calls an `ActiveSupport.on_load` hook with `:active_interactor` and
  `ActiveInteractor::Base`
- `ActiveInteractor::Context::Attributes.attributes` now excepts arguments for attributes
- `ActiveInteractor::Interactor.perform` now takes options
- `ActiveInteractor::Interactor::Context.context_class` will now first attempt to find an
  existing context class, and only create a new context class if a context is not found.
- Moved `ActiveInteractor::Organizer` to `ActiveInteractor::Organizer::Base`
- interactor, organizer, and context generators now accept `context_attributes`
  as arguments.

### Fixed

- various rails generator fixes

### Removed

- `ActiveInteractor::Configuration` use `ActiveInteractor::Config`
- `ActiveInteractor::Context::Attributes.attributes=` use `ActiveInteractor::Context#attributes`
- `ActiveInteractor::Context::Attributes.attribute_aliases`
- `ActiveInteractor::Context::Attributes.alias_attributes`
- `ActiveInteractor::Context::Attributes#clean!`
- `ActiveInteractor::Context::Attributes#keys`
- `ActiveInteractor::Interactor#fail_on_invalid_context?`
- `ActiveInteractor::Interactor#execute_rollback`
- `ActiveInteractor::Interactor#should_clean_context?`
- `ActiveInteractor::Interactor#skip_clean_context!`
- `ActiveInteractor::Interactor::Callbacks.allow_context_to_be_invalid`
- `ActiveInteractor::Interactor::Callbacks.clean_context_on_completion`
- `ActiveInteractor::Interactor::Context.context_attribute_aliases`
- `ActiveInteractor::Interactor::Execution`
- `ActiveInteractor::Interactor::Worker#run_callbacks`

## [v0.1.7] - 2019-09-10

### Fixed

- Ensure `Organizer` accurately reports context success

## [v0.1.6] - 2019-07-24

### Changed

- Lowered method complexity and enforced single responsibility

### Security

- Update simplecov: 0.16.1 → 0.17.0 (major)
- Update rake: 12.3.2 → 12.3.3 (patch)

## [v0.1.5] - 2019-06-30

### Added

- `ActiveInteractor::Error` module

### Deprecated

- `ActiveInteractor::Context::Failure` in favor of `ActiveInteractor::Error::ContextFailure`

### Security

- Update rubocop: 0.67.2 → 0.72.0 (major)
- Various dependency updates
- Update yard: 0.9.19 → 0.9.20 (minor)

## [v0.1.4] - 2019-04-12

### Added

- The ability to alias attributes on interactor contexts.

## [v0.1.3] - 2019-04-01

### Added

- Implement `each_perform` callbacks on organizers

## [v0.1.2] - 2019-04-01

### Added

- Allow the directory interactors are generated in to be configurable

## [v0.1.1] - 2019-03-30

### Fixed

- `NameError` (uninitialized constant `ActiveInteractor::Organizer`)
- `NoMethodError` (undefined method `merge` for `ActiveInteractor::Context::Base`)

## v0.1.0 - 2019-03-30

- Initial gem release

[Keep a Changelog]: https://keepachangelog.com/en/1.0.0/
[Semantic Versioning]: https://semver.org/spec/v2.0.0.html

<!-- versions -->

[Unreleased]: https://github.com/aaronmallen/activeinteractor/compare/v1.2.1...HEAD
[v1.2.1]: https://github.com/aaronmallen/activeinteractor/compare/v1.2.0...v1.2.1
[v1.2.0]: https://github.com/aaronmallen/activeinteractor/compare/v1.1.7...v1.2.0
[v1.1.7]: https://github.com/aaronmallen/activeinteractor/compare/v1.1.6...v1.1.7
[v1.1.6]: https://github.com/aaronmallen/activeinteractor/compare/v1.1.4...v1.1.6
[v1.1.4]: https://github.com/aaronmallen/activeinteractor/compare/v1.1.3...v1.1.4
[v1.1.3]: https://github.com/aaronmallen/activeinteractor/compare/v1.1.2...v1.1.3
[v1.1.2]: https://github.com/aaronmallen/activeinteractor/compare/v1.1.1...v1.1.2
[v1.1.1]: https://github.com/aaronmallen/activeinteractor/compare/v1.1.0...v1.1.1
[v1.1.0]: https://github.com/aaronmallen/activeinteractor/compare/v1.0.5...v1.1.0
[v1.0.5]: https://github.com/aaronmallen/activeinteractor/compare/v1.0.4...v1.0.5
[v1.0.4]: https://github.com/aaronmallen/activeinteractor/compare/v1.0.3...v1.0.4
[v1.0.3]: https://github.com/aaronmallen/activeinteractor/compare/v1.0.2...v1.0.3
[v1.0.2]: https://github.com/aaronmallen/activeinteractor/compare/v1.0.1...v1.0.2
[v1.0.1]: https://github.com/aaronmallen/activeinteractor/compare/v1.0.0...v1.0.1
[v1.0.0]: https://github.com/aaronmallen/activeinteractor/compare/v0.1.7...v1.0.0
[v0.1.7]: https://github.com/aaronmallen/activeinteractor/compare/v0.1.6...v0.1.7
[v0.1.6]: https://github.com/aaronmallen/activeinteractor/compare/v0.1.5...v0.1.6
[v0.1.5]: https://github.com/aaronmallen/activeinteractor/compare/v0.1.4...v0.1.5
[v0.1.4]: https://github.com/aaronmallen/activeinteractor/compare/v0.1.3...v0.1.4
[v0.1.3]: https://github.com/aaronmallen/activeinteractor/compare/v0.1.2...v0.1.3
[v0.1.2]: https://github.com/aaronmallen/activeinteractor/compare/v0.1.1...v0.1.2
[v0.1.1]: https://github.com/aaronmallen/activeinteractor/compare/v0.1.0...v0.1.1
