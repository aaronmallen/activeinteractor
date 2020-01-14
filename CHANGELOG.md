# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog],
and this project adheres to [Semantic Versioning].

## [Unreleased]

## [v1.0.0-beta.4] - 2020-01-14

### Added

- [#114] `ActiveInteractor::Organizer::InteractorInterface`
- [#114] `ActiveInteractor::Organizer::InteractorInterfaceCollection`
- [#115] `ActiveInteractor::Interactor#options`
- [#115] `ActiveInteractor::Interactor#with_options`
- [#115] `ActiveInteractor::Interactor::PerformOptions#skip_each_perform_callbacks`

### Changed

- [#115] `ActiveInteractor::Interactor::Worker#execute_perform` and `#execute_perform!` no longer accept arguments,
   use `ActiveInteractor::Interactor#with_options` instead.
- [#115] `ActiveInteractor::Organizer` can now skip `each_perform` callbacks with
  the option `skip_each_perform_callbacks`

### Removed

- [#115] `ActiveInteractor::Interactor#execute_rollback`
- [#115] `ActiveInteractor::Interactor::Worker#run_callbacks`

## [v1.0.0-beta.3] - 2020-01-12

### Added

- [#109] `ActiveInteractor::Organizer.parallel`
- [#109] `ActiveInteractor::Organizer.perform_in_parallel`
- [#109] `ActiveInteractor::Context::Base#merge`
- [#110] `ActiveInteractor::Interactor::PerformOptions`

### Changed

- [#110] `ActiveInteractor::Interactor.perform` now takes options

## [v1.0.0-beta.2] - 2020-01-07

### Added

- [#102] `ActiveInteractor::Config`
- [#102] `ActiveInteractor.config`
- [#103] `ActiveInteractor::Rails`
- [#103] `ActiveInteractor::Rails::Config`
- [#102] `ActiveInteractor::Railtie`
- [#105] interactor, organizer, and context generators now accept context_attributes
  as arguments.

### Changed

- [#102] `ActiveInteractor.logger` is now part of `ActiveInteractor.config`
- [#104] Interactor generators will no longer generate separate context classes for
  interactors if `ActiveInteractor.config.rails.generate_context_classes` is set to `false`

### Fixed

- [#103] various generator fixes

### Removed

- [#102] `ActiveInteractor.logger=` use `ActiveInteractor.config.logger=` instead

## [v1.0.0-beta.1] - 2020-01-06

### Added

- `ActiveInteractor.logger=`
- `ActiveInteractor::Base#dup`
- `ActiveInteractor::Context::Loader`
- `ActiveInteractor::Error::InvalidContextClass`
- `ActiveInteractor::Interactor::Context#context_fail!`
- `ActiveInteractor::Interactor::Context#context_rollback!`
- `ActiveInteractor::Interactor::Context.contextualize_with`
- `ActiveInteractor::Interactor::Context#finalize_context!`

### Changed

- `ActiveInteractor::Context::Attributes.attributes` now excepts arguments for attributes
- `ActiveInteractor::Generators` various improvements to rails generators
- `ActiveInteractor::Interactor::Context.context_class` will now first attempt to find an
  existing context class, and only create a new context class if a context is not found.
- `ActiveInteractor::Organizer.organize` now excepts symbols and strings as arguments.

### Removed

- `ActiveInteractor::Configuration`
- `ActiveInteractor::Context::Attributes.attributes=` in favor of `ActiveInteractor::Context#attributes`
- `ActiveInteractor::Context::Attributes.attribute_aliases`
- `ActiveInteractor::Context::Attributes#clean!`
- `ActiveInteractor::Context::Attributes#keys`
- `ActiveInteractor::Interactor#fail_on_invalid_context?`
- `ActiveInteractor::Interactor#should_clean_context?`
- `ActiveInteractor::Interactor::Callbacks.clean_context_on_completion`
- `ActiveInteractor::Interactor::Context.context_attribute_aliases`
- `ActiveInteractor::Interactor::Execution`

## [v0.1.7] - 2019-09-10

### Fixed

- [#61] Ensure `Organizer` accurately reports context success

## [v0.1.6] - 2019-07-24

### Changed

- [#45] Lowered method complexity and enforced single responsibility

### Security

- [#48] Update simplecov: 0.16.1 → 0.17.0 (major)
- [#51] Update rake: 12.3.2 → 12.3.3 (patch)

## [v0.1.5] - 2019-06-30

### Added

- [#39] `ActiveInteractor::Error` module

### Deprecated

- [#39] `ActiveInteractor::Context::Failure` in favor of `ActiveInteractor::Error::ContextFailure`

### Security

- [#33], [#37] Update rubocop: 0.67.2 → 0.72.0 (major)
- [#34] Various dependency updates
- [#38] Update yard: 0.9.19 → 0.9.20 (minor)

## [v0.1.4] - 2019-04-12

### Added

- [#28] The ability to alias attributes on interactor contexts.

## [v0.1.3] - 2019-04-01

### Added

- [#25] Implement `each_perform` callbacks on organizers

## [v0.1.2] - 2019-04-01

### Added

- [#22] Allow the directory interactors are generated in to be configurable

## [v0.1.1] - 2019-03-30

### Fixed

- [#15] `NameError` (uninitialized constant `ActiveInteractor::Organizer`)
- [#16] `NoMethodError` (undefined method `merge` for `ActiveInteractor::Context::Base`)

## v0.1.0 - 2019-03-30

- Initial gem release

[Keep a Changelog]: https://keepachangelog.com/en/1.0.0/
[Semantic Versioning]: https://semver.org/spec/v2.0.0.html

<!-- versions -->

[Unreleased]: https://github.com/aaronmallen/activeinteractor/compare/v1.0.0-beta.4...HEAD
[v1.0.0-beta.4]: https://github.com/aaronmallen/activeinteractor/compare/v1.0.0-beta.3...v1.0.0-beta.4
[v1.0.0-beta.3]: https://github.com/aaronmallen/activeinteractor/compare/v1.0.0-beta.2...v1.0.0-beta.3
[v1.0.0-beta.2]: https://github.com/aaronmallen/activeinteractor/compare/v1.0.0-beta.1...v1.0.0-beta.2
[v1.0.0-beta.1]: https://github.com/aaronmallen/activeinteractor/compare/v0.1.7...v1.0.0-beta.1
[v0.1.7]: https://github.com/aaronmallen/activeinteractor/compare/v0.1.6...v0.1.7
[v0.1.6]: https://github.com/aaronmallen/activeinteractor/compare/v0.1.5...v0.1.6
[v0.1.5]: https://github.com/aaronmallen/activeinteractor/compare/v0.1.4...v0.1.5
[v0.1.4]: https://github.com/aaronmallen/activeinteractor/compare/v0.1.3...v0.1.4
[v0.1.3]: https://github.com/aaronmallen/activeinteractor/compare/v0.1.2...v0.1.3
[v0.1.2]: https://github.com/aaronmallen/activeinteractor/compare/v0.1.1...v0.1.2
[v0.1.1]: https://github.com/aaronmallen/activeinteractor/compare/v0.1.0...v0.1.1

<!-- pull requests and issues -->

[#15]: https://github.com/aaronmallen/activeinteractor/pull/15
[#16]: https://github.com/aaronmallen/activeinteractor/pull/16
[#22]: https://github.com/aaronmallen/activeinteractor/pull/22
[#25]: https://github.com/aaronmallen/activeinteractor/pull/25
[#28]: https://github.com/aaronmallen/activeinteractor/pull/28
[#33]: https://github.com/aaronmallen/activeinteractor/pull/33
[#34]: https://github.com/aaronmallen/activeinteractor/pull/34
[#37]: https://github.com/aaronmallen/activeinteractor/pull/37
[#38]: https://github.com/aaronmallen/activeinteractor/pull/38
[#39]: https://github.com/aaronmallen/activeinteractor/pull/39
[#45]: https://github.com/aaronmallen/activeinteractor/pull/45
[#48]: https://github.com/aaronmallen/activeinteractor/pull/48
[#51]: https://github.com/aaronmallen/activeinteractor/pull/51
[#61]: https://github.com/aaronmallen/activeinteractor/pull/61
[#102]: https://github.com/aaronmallen/activeinteractor/pull/102
[#103]: https://github.com/aaronmallen/activeinteractor/pull/103
[#104]: https://github.com/aaronmallen/activeinteractor/pull/104
[#105]: https://github.com/aaronmallen/activeinteractor/pull/105
[#109]: https://github.com/aaronmallen/activeinteractor/pull/109
[#110]: https://github.com/aaronmallen/activeinteractor/pull/110
[#114]:https://github.com/aaronmallen/activeinteractor/pull/114
[#115]: https://github.com/aaronmallen/activeinteractor/pull/115
