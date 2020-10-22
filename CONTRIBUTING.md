# Contributing

We love pull requests from everyone. By participating in this project, you
agree to abide by the our [code of conduct].

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by writing or editing documentation
* by writing specifications
* by writing code ( **no patch is too small** : fix typos, add comments, clean up inconsistent whitespace )
* by refactoring code
* by closing [issues]
* by reviewing patches

## Submitting an Issue

* We use the [GitHub issue tracker][issues] to track bugs and features.
* Before submitting a bug report or feature request, check to make sure it hasn't
  already been submitted.
* When submitting a bug report, please include a [Gist][] that includes a stack
  trace and any details that may be necessary to reproduce the bug, including
  your gem version, Ruby version, and operating system.  Ideally, a bug report
  should include a pull request with failing specs.

## Cleaning up issues

* Issues that have no response from the submitter will be closed after 30 days.
* Issues will be closed once they're assumed to be fixed or answered. If the
  maintainer is wrong, it can be opened again.
* If your issue is closed by mistake, please understand and explain the issue.
  We will happily reopen the issue.

## Submitting a Pull Request

1. [Fork][fork] the [official repository][repo].
1. [Create a topic branch.][branch]
1. Implement your feature or bug fix.
1. Add, commit, and push your changes.
1. [Submit a pull request.][pr]

### Branches and Versions

Each major/minor version of the project has a corresponding stable branch. For example version `1.1.1` is based off the
`1-1-stable` branch, likewise version `1.2.0` will be based off the `1-2-stable` branch. If your pull request is to
address an issue with a particular version your work should be based off the appropriate branch, and your pull request
should be set to merge into that branch as well. There may be occasions where you will be asked to open a separate PR
to apply your patch changes to the main branch or other version stable branches.

### Notes

* Please add tests if you changed code. Contributions without tests won't be accepted.
* If you don't know how to add tests, please put in a PR and leave a comment
  asking for help. We love helping!
* Please don't update the Gem version.

## Setting Up

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Running the test suite

The default rake task will run the full test suite and lint:

```sh
bundle exec rake
```

To run an individual rspec test, you can provide a path and line number:

```sh
bundle exec rspec spec/path/to/spec.rb:123
```

## Formatting and Style

Our style guide is defined in [`.rubocop.yml`](https://github.com/aaronmallen/activeinteractor/blob/main/.rubocop.yml)

To run the linter:

```sh
bin/rubocop
```

To run the linter with auto correct:

```sh
bin/rubocop -A
```

Inspired by [factory_bot]

[code_of_conduct]: CODE_OF_CONDUCT.md
[repo]: https://github.com/aaronmallen/activeinteractor/tree/main
[issues]: https://github.com/aaronmallen/activeinteractor/issues
[fork]: https://help.github.com/articles/fork-a-repo/
[branch]: https://help.github.com/articles/creating-and-deleting-branches-within-your-repository/
[pr]: https://help.github.com/articles/using-pull-requests/
[gist]: https://gist.github.com/
[factory_bot]: https://github.com/thoughtbot/factory_bot/blob/master/CONTRIBUTING.md
