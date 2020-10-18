# ActiveInteractor

[![Version](https://img.shields.io/gem/v/activeinteractor.svg?logo=ruby)](https://rubygems.org/gems/activeinteractor)
[![Build Status](https://github.com/aaronmallen/activeinteractor/workflows/Build/badge.svg)](https://github.com/aaronmallen/activeinteractor/actions)
[![Maintainability](https://api.codeclimate.com/v1/badges/2f1cb318f681a1eebb27/maintainability)](https://codeclimate.com/github/aaronmallen/activeinteractor/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/2f1cb318f681a1eebb27/test_coverage)](https://codeclimate.com/github/aaronmallen/activeinteractor/test_coverage)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](https://www.rubydoc.info/gems/activeinteractor)
[![Inline docs](http://inch-ci.org/github/aaronmallen/activeinteractor.svg?branch=main)](http://inch-ci.org/github/aaronmallen/activeinteractor)
[![License](https://img.shields.io/github/license/aaronmallen/activeinteractor.svg?maxAge=300)](https://github.com/aaronmallen/activeinteractor/blob/main/LICENSE)

An implementation of the [command pattern] for Ruby with [ActiveModel::Validations] inspired by the
[interactor][collective_idea_interactors] gem. Rich support for attributes, callbacks, and validations,
and thread safe performance methods.

Reduce controller bloat with procedural service objects. Checkout this [Medium article] for a crash
course on how to use ActiveInteractors. Read the [wiki] for detailed usage information.

## Features

* [Context validation][wiki_context_validation]
* [Callbacks][wiki_callbacks]
* Thread safe performance calls
* Organize multiple interactors [conditionally][wiki_organizers_conditionally] or in [parallel][wiki_organizers_parallel]

## Getting Started

Add this line to your application's Gemfile:

```ruby
gem 'activeinteractor', require: 'active_interactor'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install activeinteractor
```

## Usage

Be sure to read the [wiki] for detailed information on how to use ActiveInteractor.

For technical documentation please see the gem's [ruby docs].

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem in your local machine, run `bundle exec rake install`.

## Contributing

Read our guidelines for [Contributing](CONTRIBUTING.md).

## Acknowledgements

* Special thanks to [@collectiveidea] for their amazing foundational work on
  the [interactor][collective_idea_interactors] gem.
* Special thanks to the [@rails] team for their work on [ActiveModel][active_model_git]
  and [ActiveSupport][active_support_git] gems.

## License

The gem is available as open source under the terms of the [MIT License][mit_license].

[@collectiveidea]: https://github.com/collectiveidea
[@rails]: https://github.com/rails
[active_model_git]: https://github.com/rails/rails/tree/master/activemodel
[active_support_git]: https://github.com/rails/rails/tree/master/activesupport
[ActiveModel::Validations]: https://api.rubyonrails.org/classes/ActiveModel/Validations.html
[business_logic_wikipedia]: https://en.wikipedia.org/wiki/Business_logic
[collective_idea_interactors]: https://github.com/collectiveidea/interactor
[command pattern]: https://en.wikipedia.org/wiki/Command_pattern
[Medium article]: https://medium.com/@aaronmallen/activeinteractor-8557c0dc78db
[mit_license]: https://opensource.org/licenses/MIT
[ruby docs]: https://www.rubydoc.info/gems/activeinteractor
[wiki]: https://github.com/aaronmallen/activeinteractor/wiki
[wiki_callbacks]: https://github.com/aaronmallen/activeinteractor/wiki/Callbacks
[wiki_context_validation]: https://github.com/aaronmallen/activeinteractor/wiki/Context#validating-the-context
[wiki_organizers_conditionally]: https://github.com/aaronmallen/activeinteractor/wiki/Interactors#organizing-interactors-conditionally
[wiki_organizers_parallel]: https://github.com/aaronmallen/activeinteractor/wiki/Interactors#running-interactors-in-parallel
