# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog],
and this project adheres to [Semantic Versioning].

## [Unreleased]

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

[Unreleased]: https://github.com/aaronmallen/activeinteractor/compare/v0.1.5..HEAD
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
