# ActiveInteractor

[![Version](https://img.shields.io/gem/v/activeinteractor.svg?logo=ruby)](https://rubygems.org/gems/activeinteractor)
[![License](https://img.shields.io/github/license/aaronmallen/activeinteractor.svg?maxAge=300)](https://github.com/aaronmallen/activeinteractor/blob/master/LICENSE)
[![Dependencies](https://img.shields.io/depfu/aaronmallen/activeinteractor.svg?maxAge=300)](https://depfu.com/github/aaronmallen/activeinteractor)

[![Build Status](https://github.com/aaronmallen/activeinteractor/workflows/Build/badge.svg)](https://github.com/aaronmallen/activeinteractor/actions)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/aaronmallen/activeinteractor.svg?maxAge=300)](https://codeclimate.com/github/aaronmallen/activeinteractor/maintainability)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/be92c4ecf12347da82d266f6a4368b6e)](https://www.codacy.com/manual/aaronmallen/activeinteractor?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=aaronmallen/activeinteractor&amp;utm_campaign=Badge_Grade)
[![Test Coverage](https://img.shields.io/codeclimate/coverage/aaronmallen/activeinteractor.svg?maxAge=300)](https://codeclimate.com/github/aaronmallen/activeinteractor/test_coverage)

Ruby interactors with [ActiveModel::Validations] based on the [interactor][collective_idea_interactors] gem.

<!-- TOC -->

* [Getting Started](#getting-started)
* [What is an Interactor](#what-is-an-interactor)
* [Usage](#usage)
  * [Context](#context)
    * [Adding to the Context](#adding-to-the-context)
    * [Failing the Context](#failing-the-context)
    * [Dealing with Failure](#dealing-with-failure)
    * [Context Attributes](#context-attributes)
    * [Validating the Context](#validating-the-context)
  * [Using Interactors](#using-interactors)
    * [Kinds of Interactors](#kinds-of-interactors)
      * [Interactors](#interactors)
      * [Organizers](#organizers)
      * [Parallel Organizers](#parallel-organizers)
    * [Rollback](#rollback)
    * [Callbacks](#callbacks)
      * [Validation Callbacks](#validation-callbacks)
      * [Perform Callbacks](#perform-callbacks)
      * [Rollback Callbacks](#rollback-callbacks)
      * [Organizer Callbacks](#organizer-callbacks)
* [Working With Rails](#working-with-rails)
* [Development](#development)
* [Contributing](#contributing)
* [Acknowledgements](#acknowledgements)
* [License](#license)

<!-- TOC -->

## Getting Started

Add this line to your application's Gemfile:

```ruby
gem 'activeinteractor'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install activeinteractor
```

## What is an Interactor

An interactor is a simple, single-purpose service object.

Interactors can be used to reduce the responsibility of your controllers,
workers, and models and encapsulate your application's [business logic][business_logic_wikipedia].
Each interactor represents one thing that your application does.

## Usage

### Context

Each interactor will have it's own immutable context and context class.  All context classes should
inherit from `ActiveInteractor::Context::Base`. By default an interactor will attempt to find an existing
class following the naming conventions: `MyInteractor::Context` or `MyInteractorContext`.  If no class
is found a context class will be created using the naming convention `MyInteractor::Context` for example:

```ruby
class MyInteractor < ActiveInteractor::Base; end
class MyInteractor::Context < ActiveInteractor::Context::Base; end

MyInteractor.context_class #=> MyInteractor::Context
```

```ruby
class MyInteractorContext < ActiveInteractor::Context::Base; end
class MyInteractor < ActiveInteractor::Base; end

MyInteractor.context_class #=> MyInteractorContext
```

```ruby
class MyInteractor < ActiveInteractor::Base; end

MyInteractor.context_class #=> MyInteractor::Context
```

Additionally you can manually specify a context for an interactor with the `contextualize_with`
method.

```ruby
class MyGenericContext < ActiveInteractor::Context::Base; end

class MyInteractor
  contextualize_with :my_generic_context
end

MyInteractor.context_class #=> MyGenericContext
```

An interactor's context contains everything the interactor needs to do its work. When an interactor does its single purpose,
it affects its given context.

#### Adding to the Context

All instances of context inherit from `OpenStruct`. As an interactor runs it can add information to
it's context.

```ruby
class MyInteractor
  def perform
    context.user = User.create(...)
  end
end
```

#### Failing the Context

When something goes wrong in your interactor, you can flag the context as failed.

```ruby
context.fail!
```

When given an argument of an instance of `ActiveModel::Errors`, the `#fail!` method can also update the context.
The following are equivalent:

```ruby
context.errors.merge!(user.errors)
context.
```

```ruby
context.fail!(user.errors)
```

You can ask a context if it's a failure:

```ruby
class MyInteractor
  def perform
    context.fail!
  end
end

result = MyInteractor.perform
result.failure? #=> true
```

or if it's a success:

```ruby
class MyInteractor
  def perform
    context.user = User.create(...)
  end
end

result = MyInteractor.perform
result.success? #=> true
```

#### Dealing with Failure

`context.fail!` always throws an exception of type `ActiveInteractor::Error::ContextFailure`.

Normally, however, these exceptions are not seen. In the recommended usage, the consuming object invokes the interactor
using the class method `perform`, then checks the `success?` method of the context.

This works because the `perform` class method swallows exceptions. When unit testing an interactor, if calling custom business
logic methods directly and bypassing `perform`, be aware that `fail!` will generate such exceptions.

See [Using Interactors](#using-interactors), below, for the recommended usage of `perform` and `success?`.

#### Context Attributes

Each context instance have basic attribute assignment methods which can be invoked directly from the interactor.
You never need to directly interface with an interactor's context class. Assigning attributes to a context is a
simple way to explicitly defined what properties a context should have after an interactor has done it's work.

You can see what attributes are defined on a given context with the `#attributes` method:

```ruby
class MyInteractorContext < ActiveInteractor::Context::Base
  attributes :first_name, :last_name, :email, :user
end

class MyInteractor < ActiveInteractor::Base; end

result = MyInteractor.perform(
  first_name: 'Aaron',
  last_name: 'Allen',
  email: 'hello@aaronmallen.me',
  occupation: 'Software Dude'
)
#=> <#MyInteractor::Context first_name='Aaron' last_name='Allen' email='hello@aaronmallen.me' occupation='Software Dude'>

result.attributes #=> { first_name: 'Aaron', last_name: 'Allen', email: 'hello@aaronmallen.me' }
result.occupation #=> 'Software Dude'
```

#### Validating the Context

ActiveInteractor delegates all the validation methods provided by [ActiveModel::Validations] onto an interactor's
context class from the interactor itself. All of the methods found in [ActiveModel::Validations] can be invoked directly
on your interactor with the prefix `context_`. However this can be confusing and it is recommended to make all validation
calls on a context class directly.

ActiveInteractor provides two validation callback steps:

* `:calling` used before `#perform` is invoked on an interactor
* `:called` used after `#perform` is invoked on an interactor

A basic implementation might look like this:

```ruby
class MyInteractorContext < ActiveInteractor::Context::Base
  attributes :first_name, :last_name, :email, :user
  # only validates presence before perform is invoked
  validates :first_name, presence: true, on: :calling
  # validates before and after perform is invoked
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  # validates after perform is invoked
  validates :user, presence: true, on: :called
  validate :user_is_a_user, on: :called

  private

  def user_is_a_user
    return if user.is_a?(User)

    errors.add(:user, :invalid)
  end
end

class MyInteractor < ActiveInteractor::Base
  def perform
    context.user = User.create_with(
      first_name: context.first_name,
      last_name: context.last_name
    ).find_or_create_by(email: context.email)
  end
end

result = MyInteractor.perform(last_name: 'Allen')
#=> <#MyInteractor::Context last_name='Allen>
result.failure? #=> true
result.valid? #=> false
result.errors[:first_name] #=> ['can not be blank']

result = MyInterator.perform(first_name: 'Aaron', email: 'hello@aaronmallen.me')
#=> <#MyInteractor::Context first_name='Aaron' email='hello@aaronmallen.me' user=<#User ...>>
result.success? #=> true
result.valid? #=> true
result.errors.empty? #=> true
```

### Using Interactors

Most of the time, your application will use its interactors from its controllers. The following controller:

```ruby
class SessionsController < ApplicationController
  def create
    if user = User.authenticate(session_params[:email], session_params[:password])
      session[:user_token] = user.secret_token
      redirect_to user
    else
      flash.now[:message] = "Please try again."
      render :new
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
```

can be refactored to:

```ruby
class SessionsController < ApplicationController
  def create
    result = AuthenticateUser.perform(session_params)

    if result.success?
      session[:user_token] = result.token
      redirect_to result.user
    else
      flash.now[:message] = t(result.errors.full_messages)
      render :new
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
```

given the basic interactor and context:

```ruby
class AuthenticateUserContext < ActiveInteractor::Context::Base
  attributes :email, :password, :user, :token
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true
  validates :user, presence: true, on: :called
end

class AuthenticateUser < ActiveInteractor::Base
  def perform
    context.user = User.authenticate(
      context.email,
      context.password
    )
    context.token = context.user.secret_token
  end
end
```

The `perform` class method is the proper way to invoke an interactor. The hash argument is converted to the interactor instance's
context. The `perform` instance method is invoked along with any callbacks and validations that the interactor might define.
Finally, the context (along with any changes made to it) is returned.

#### Kinds of Interactors

There are two kinds of interactors built into the Interactor library: basic interactors and organizers.

##### Interactors

A basic interactor is a class that includes Interactor and defines `perform`.\

```ruby
class AuthenticateUser < ActiveInteractor::Base
  def perform
    user = User.authenticate(context.email, context.password)
    if user
      context.user = user
      context.token = user.secret_token
    else
      context.fail!
    end
  end
end
```

Basic interactors are the building blocks. They are your application's single-purpose units of work.

##### Organizers

An organizer is an important variation on the basic interactor. Its single purpose is to run other interactors.

```ruby
class CreateOrder < ActiveInteractor::Base
  def perform
    ...
  end
end

class ChargeCard < ActiveInteractor::Base
  def perform
    ...
  end
end

class SendThankYou < ActiveInteractor::Base
  def perform
    ...
  end
end

class PlaceOrder < ActiveInteractor::Organizer

  organize :create_order, :charge_card, :send_thank_you
end
```

In the controller, you can run the `PlaceOrder` organizer just like you would any other interactor:

```ruby
class OrdersController < ApplicationController
  def create
    result = PlaceOrder.perform(order_params: order_params)

    if result.success?
      redirect_to result.order
    else
      @order = result.order
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit!
  end
end
```

The organizer passes its context to the interactors that it organizes, one at a time and in order. Each interactor may
change that context before it's passed along to the next interactor.

##### Parallel Organizers

Organizers can be told to run their interactors in parallel with the `#perform_in_parallel` class method.  This
will run each interactor in parallel with one and other only passing the original context to each organizer.
This means each interactor must be able to perform without dependencies on prior interactor runs.

```ruby
class CreateNewUser < ActiveInteractor::Base
  def perform
    context.user = User.create(
      first_name: context.first_name,
      last_name: context.last_name
    )
  end
end

class LogNewUserCreation < ActiveInteractor::Base
  def perform
    context.log = Log.create(
      event: 'new user created',
      first_name: context.first_name,
      last_name: context.last_name
    )
  end
end

class CreateUser < ActiveInteractor::Organizer
  perform_in_parallel
  organize :create_new_user, :log_new_user_creation
end

CreateUser.perform(first_name: 'Aaron', last_name: 'Allen')
#=> <#CreateUser::Context first_name='Aaron' last_name='Allen' user=>#<User ...> log=<#Log ...>>
```

#### Rollback

If any one of the organized interactors fails its context, the organizer stops. If the `ChargeCard` interactor fails,
`SendThankYou` is never called.

In addition, any interactors that had already run are given the chance to undo themselves, in reverse order.
Simply define the rollback method on your interactors:

```ruby
class CreateOrder < ActiveInteractor::Base
  def perform
    order = Order.create(order_params)

    if order.persisted?
      context.order = order
    else
      context.fail!
    end
  end

  def rollback
    context.order.destroy
  end
end
```

#### Callbacks

ActiveInteractor uses [ActiveModel::Callbacks] and [ActiveModel::Validations::Callbacks] on context validation, perform,
and rollback. Callbacks can be defined with a `block`, `Proc`, or `Symbol` method name and take the same conditional arguments
outlined in those two modules.

##### Validation Callbacks

We can do work before an interactor's context is validated with the `before_context_validation` method:

```ruby
class MyInteractorContext < ActiveInteractor::Context::Base
  attributes :first_name, :last_name, :email
  validates :last_name, presence: true
end

class MyInteractor < ActiveInteractor::Base
  before_context_validation { context.last_name ||= 'Unknown' }
end

result = MyInteractor.perform(first_name: 'Aaron', email: 'hello@aaronmallen.me')
result.valid? #=> true
result.last_name #=> 'Unknown'
```

We can do work after an interactor's context is validated with the `after_context_validation` method:

```ruby
class MyInteractorContext < ActiveInteractor::Context::Base
  attributes :first_name, :last_name, :email
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
end

class MyInteractor < ActiveInteractor::Base
  after_context_validation { context.email&.downcase! }
end

result = MyInteractor.perform(first_name: 'Aaron', last_name: 'Allen', email: 'HELLO@AARONMALLEN.ME')
result.valid? #=> true
result.email #=> 'hello@aaronmallen.me'
```

##### Perform Callbacks

We can do work before `perform` is invoked with the `before_perform` method:

```ruby
class MyInteractor < ActiveInteractor::Base
  before_perform :print_start

  def perform
    puts 'Performing'
  end

  private

  def print_start
    puts 'Start'
  end
end

MyInteractor.perform
"Start"
"Performing"
#=> <#MyInteractor::Context...>
```

We can do work around `perform` invokation with the `around_perform` method:

```ruby
class MyInteractor < ActiveInteractor::Base
  around_perform :track_time

  def perform
    sleep(1)
  end

  private

  def track_time
    context.start_time = Time.now.utc
    yield
    context.end_time = Time.now.utc
  end
end

result = MyInteractor.perform
result.start_time #=> 2019-01-01 00:00:00 UTC
result.end_time #=> 2019-01-01 00:00:01 UTC
```

We can do work after `perform` is invoked with the `after_perform` method:

```ruby
class MyInteractor < ActiveInteractor::Base
  after_perform :print_done

  def perform
    puts 'Performing'
  end

  private

  def print_done
    puts 'Done'
  end
end

MyInteractor.perform
"Performing"
"Done"
#=> <#MyInteractor::Context...>
```

##### Rollback Callbacks

We can do work before `rollback` is invoked with the `before_rollback` method:

```ruby
class MyInteractor < ActiveInteractor::Base
  before_rollback :print_start

  def perform
    context.fail!
  end

  def rollback
    puts 'Rolling Back'
  end

  private

  def print_start
    puts 'Start'
  end
end

MyInteractor.perform
"Start"
"Rolling Back"
#=> <#MyInteractor::Context...>
```

We can do work around `rollback` invokation with the `around_rollback` method:

```ruby
class MyInteractor < ActiveInteractor::Base
  around_rollback :track_time

  def perform
    context.fail!
  end

  def rollback
    sleep(1)
  end

  private

  def track_time
    context.start_time = Time.now.utc
    yield
    context.end_time = Time.now.utc
  end
end

result = MyInteractor.perform
result.start_time #=> 2019-01-01 00:00:00 UTC
result.end_time #=> 2019-01-01 00:00:01 UTC
```

We can do work after `rollback` is invoked with the `after_rollback` method:

```ruby
class MyInteractor < ActiveInteractor::Base
  after_rollback :print_done

  def perform
    context.fail!
  end

  def rollback
    puts 'Rolling Back'
  end

  private

  def print_done
    puts 'Done'
  end
end

MyInteractor.perform
"Rolling Back"
"Done"
#=> <#MyInteractor::Context...>
```

##### Organizer Callbacks

We can do worker before `perform` is invoked on each interactor in an [Organizer](#organizers) with the
`before_each_perform` method:

```ruby
class MyInteractor1 < ActiveInteractor::Base
  def perform
    puts 'MyInteractor1'
  end
end

class MyInteractor2 < ActiveInteractor::Base
  def perform
    puts 'MyInteractor2'
  end
end

class MyOrganizer < ActiveInteractor::Organizer
  before_each_perform :print_start

  organized MyInteractor1, MyInteractor2

  private

  def print_start
    puts "Start"
  end
end

MyOrganizer.perform
"Start"
"MyInteractor1"
"Start"
"MyInteractor2"
#=> <MyOrganizer::Context...>
```

We can do worker around `perform` is invokation on each interactor in an [Organizer](#organizers) with the
`around_each_perform` method:

```ruby
 class MyInteractor1 < ActiveInteractor::Base
  def perform
    puts 'MyInteractor1'
    sleep(1)
  end
end

class MyInteractor2 < ActiveInteractor::Base
  def perform
    puts 'MyInteractor2'
    sleep(1)
  end
end

class MyOrganizer < ActiveInteractor::Organizer
  around_each_perform :print_time

  organized MyInteractor1, MyInteractor2

  private

  def print_time
    puts Time.now.utc
    yield
    puts Time.now.utc
  end
end

MyOrganizer.perform
"2019-01-01 00:00:00 UTC"
"MyInteractor1"
"2019-01-01 00:00:01 UTC"
"2019-01-01 00:00:01 UTC"
"MyInteractor2"
"2019-01-01 00:00:02 UTC"
#=> <MyOrganizer::Context...>
```

We can do worker after `perform` is invoked on each interactor in an [Organizer](#organizers) with the
`after_each_perform` method:

```ruby
class MyInteractor1 < ActiveInteractor::Base
  def perform
    puts 'MyInteractor1'
  end
end

class MyInteractor2 < ActiveInteractor::Base
  def perform
    puts 'MyInteractor2'
  end
end

class MyOrganizer < ActiveInteractor::Organizer
  after_each_perform :print_done

  organized MyInteractor1, MyInteractor2

  private

  def print_done
    puts "Done"
  end
end

MyOrganizer.perform
"MyInteractor1"
"Done"
"MyInteractor2"
"Done"
#=> <MyOrganizer::Context...>
```

## Working With Rails

If you're working with a rails project ActiveInteractor comes bundled with some useful generators
to help speed up development.  You should first run the install generator with:

```bash
rails generate active_interactor:install [directory]
```

The `directory` option allows you to customize what directory interactors will live in within your
application (defaults to 'interactors').

This will create an initializer a some new classes `ApplicationInteractor`, `ApplicationOrganizer` and
`ApplicationContext` in the `app/<directory>` directory.

You can then automatically generate interactors, organizers, and contexts with:

```bash
rails generate interactor MyInteractor
```

```bash
rails generate interactor:organizer MyInteractor1 MyInteractor2
```

```bash
rails generate interactor:context MyContext
```

These generators will automatically create the approriate classes and matching spec or test files.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Read our guidelines for [Contributing](CONTRIBUTING.md).

## Acknowledgements

* Special thanks to [@collectiveidea] for their amazing foundational work on
  the [interactor][collective_idea_interactors] gem.
* Special thanks to the [@rails] team for their work on [ActiveModel][active_model_git]
  and [ActiveSupport][active_support_git] gems.

## License

The gem is available as open source under the terms of the [MIT License][mit_license].

[ActiveModel::Callbacks]: https://api.rubyonrails.org/classes/ActiveModel/Callbacks.html
[ActiveModel::Validations]: https://api.rubyonrails.org/classes/ActiveModel/Validations.html
[ActiveModel::Validations::Callbacks]: https://api.rubyonrails.org/classes/ActiveModel/Validations/Callbacks.html
[collective_idea_interactors]: https://github.com/collectiveidea/interactor
[business_logic_wikipedia]: https://en.wikipedia.org/wiki/Business_logic
[@collectiveidea]: https://github.com/collectiveidea
[@rails]: https://github.com/rails
[active_model_git]: https://github.com/rails/rails/tree/master/activemodel
[active_support_git]: https://github.com/rails/rails/tree/master/activesupport
[mit_license]: https://opensource.org/licenses/MIT
