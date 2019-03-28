# ActiveInteractor

[![Version](https://img.shields.io/gem/v/activeinteractor.svg?logo=ruby&style=for-the-badge)](https://rubygems.org/gems/activeinteractor)
[![License](https://img.shields.io/github/license/aaronmallen/activeinteractor.svg?maxAge=300&style=for-the-badge)](https://github.com/aaronmallen/activeinteractor/blob/master/LICENSE)
[![Dependencies](https://img.shields.io/depfu/aaronmallen/activeinteractor.svg?maxAge=300&style=for-the-badge)](https://depfu.com/github/aaronmallen/activeinteractor)

[![Build Status](https://img.shields.io/travis/com/aaronmallen/activeinteractor/master.svg?logo=travis&maxAge=300&style=for-the-badge)](https://www.travis-ci.com/aaronmallen/activeinteractor)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/aaronmallen/activeinteractor.svg?maxAge=300&style=for-the-badge)](https://codeclimate.com/github/aaronmallen/activeinteractor/maintainability)
[![Test Coverage](https://img.shields.io/codeclimate/coverage/aaronmallen/activeinteractor.svg?maxAge=300&style=for-the-badge)](https://codeclimate.com/github/aaronmallen/activeinteractor/test_coverage)

Ruby interactors with [ActiveModel::Validations] based on the [interactors][collective_idea_interactors] gem.

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

If you're working with a rails project you will also want to run:

```bash
rails generate active_interactor:install
```

This will create an initializer and a new class called `ApplicationInteractor`
at `app/interactors/application_interactor.rb`

you can then automatically generate interactors and interactor organizers with:

```bash
rails generate interactor MyInteractor
```

```bash
rails generate interactor:organizer MyInteractor1 MyInteractor2
```

These two generators will automatically create an interactor class which
inherits from `ApplicationInteractor` and a matching spec or test file.

## What is an Interactor

An interactor is a simple, single-purpose service object.

Interactors can be used to reduce the responsibility of your controllers,
workers, and models and encapsulate your application's [business logic][business_logic_wikipedia].
Each interactor represents one thing that your application does.

## Usage

### Context

Each interactor will have it's own `context` and `context` class.  For example:

```ruby
class MyInteractor < ActiveInteractor::Base
end

MyInteractor.context_class #=> MyInteractor::Context

interactor = MyInteractor.new #=> <#MyInteractor>
interactor.context #=> <#MyInteractor::Context>
```

An interactor's context contains everything the interactor needs to do its work.
When an interactor does its single purpose, it affects its given context.

#### Adding to the Context

All instances of `context` inherit from `OpenStruct`. As an interactor runs it can
add information to it's `context`.

```ruby
context.user = user
```

#### Failing the Context

When something goes wrong in your interactor, you can flag the context as failed.

```ruby
context.fail!
```

When given a hash argument or an instance of `ActiveModel::Errors`, the fail!
method can also update the context. The following are equivalent:

```ruby
context.errors.merge!(user.errors)
context.fail!
```

```ruby
context.fail!(user.errors)
```

You can ask a context if it's a failure:

```ruby
context.failure? #=> false
context.fail!
context.failure? #=> true
```

or if it's a success:

```ruby
context.success? # => true
context.fail!
context.success? # => false
```

#### Dealing with Failure

`context.fail!` always throws an exception of type `ActiveInteractor::Context::Failure`.

Normally, however, these exceptions are not seen. In the recommended usage, the consuming
object invokes the interactor using the class method call, then checks the `success?` method of
the context.

This works because the call class method swallows exceptions. When unit testing an interactor, if calling
custom business logic methods directly and bypassing call, be aware that `fail!` will generate such exceptions.

See [Using Interactors](#using-interactors), below, for the recommended usage of `perform` and `success?`.

#### Context Attributes

Each `context` instance have basic attribute assignment methods which can be invoked directly
from the interactor.  You never need to directly interface with an interactor's context class.
Assigning attributes to a `context` is a simple way to explicitly defined what properties a
`context` should have after an interactor has done it's work.

You can see what attributes are defined on a given `context` with the `#attributes` method:

```ruby
class MyInteractor < ActiveInteractor::Base
  # we define user as an attribute because it will be assigned a value
  # in the perform method.
  context_attributes :first_name, :last_name, :email, :user
end

context = MyInteractor.perform(
  first_name: 'Aaron',
  last_name: 'Allen',
  email: 'hello@aaronmallen.me',
  occupation: 'Software Dude'
)
#=> <#<MyInteractor::Context first_name='Aaron', last_name='Allen, email='hello@aaronmallen.me', occupation='Software Dude'>

context.attributes #=> { first_name: 'Aaron', last_name: 'Allen', email: 'hello@aaronmallen.me' }
context.occupation #=> 'Software Dude'
```

You can see what properties are defined on a given `context` with the `#keys` method
regardless of whether or not the properties are defined in a `context#attributes`:

```ruby
context.keys #=> [:first_name, :last_name, :email, :occupation]
```

Finally you can invoke `#clean!` on a context to remove any properties not explicitly
defined in a `context#attributes`:

```ruby
context.clean! #=> { occupation: 'Software Dude' }
context.occupation #=> nil
```

#### Validating the Context

`ActiveInteractor` delegates all the validation methods provided by [ActiveModel::Validations]
onto an interactor's context class from the interactor itself.  All of the methods found in
[ActiveModel::Validations] can be invoked directly on your interactor with the prefix `context_`.

`ActiveInteractor` provides two validation callback steps:

* `:calling` used before `#perform` is invoked
* `:called` used after `#perform` is invoked

A basic implementation might look like this:

```ruby
class MyInteractor < ActiveInteractor::Base
  context_attributes :first_name, :last_name, :email, :user
  # only validates presence before perform is invoked
  context_validates :first_name, presence: true, on: :calling
  # validates before and after perform is invoked
  context_validates :email, presence: true,
                            format: { with: URI::MailTo::EMAIL_REGEXP }
  # validates after perform is invoked
  context_validates :user, presence: true, on: :called
  context_validate :user_is_a_user, on: :called

  def perform
    context.user = User.create_with(
      first_name: context.first_name,
      last_name: context.last_name
    ).find_or_create_by(email: context.email)
  end

  private

  def user_is_a_user
    return if context.user.is_a?(User)

    context.errors.add(:user, :invalid)
  end
end

context = MyInteractor.perform(last_name: 'Allen')
#=> <#MyInteractor::Context last_name='Allen>
context.failure? #=> true
context.valid? #=> false
context.errors[:first_name] #=> ['can not be blank']

context = MyInterator.perform(first_name: 'Aaron', email: 'hello@aaronmallen.me')
#=> <#MyInteractor::Context first_name='Aaron', email='hello@aaronmallen.me'>
context.success? #=> true
context.valid? #=> true
context.errors.empty? #=> true
```

### Callbacks

`ActiveInteractor` uses [ActiveModel::Callbacks] and [ActiveModel::Validations::Callbacks]
on context validation, `perform`, and `rollback`.  Callbacks can be defined with a `block`,
`Proc`, or `Symbol` method name and take the same conditional arguments outlined
in those two modules.

**NOTE:** When using symbolized method names as arguments the context class
will first attempt to invoke the method on itself, if it cannot find the defined
method it will attempt to invoke it on the interactor.  Be concious of scope
when defining these methods.

#### Validation Callbacks

We can do work before an interactor's context is validated with the `before_context_validation` method:

```ruby
class MyInteractor < ActiveInteractor::Base
  context_attributes :first_name, :last_name, :email, :user
  context_validates :last_name, presence: true
  before_context_validation { last_name ||= 'Unknown' }
end

context = MyInteractor.perform(first_name: 'Aaron', email: 'hello@aaronmallen.me')
context.valid? #=> true
context.last_name #=> 'Unknown'
```

We can do work after an interactor's context is validated with the `after_context_validation` method:

```ruby
class MyInteractor < ActiveInteractor::Base
  context_attributes :first_name, :last_name, :email, :user
  context_validates :email, presence: true,
                            format: { with: URI::MailTo::EMAIL_REGEXP }
  after_context_validation :downcase_email!

  private

  def downcase_email
    context.email = context.email&.downcase!
  end
end

context = MyInteractor.perform(first_name: 'Aaron', email: 'HELLO@aaronmallen.me')
context.email #=> 'hello@aaronmallen.me'
```

We can prevent a context from failing when invalid by invoking the
`allow_context_to_be_invalid` class method:

```ruby
class MyInteractor < ActiveInteractor::Base
  allow_context_to_be_invalid
  context_attributes :first_name, :last_name, :email, :user
  context_validates :first_name, presence: true
end

context = MyInteractor.perform(email: 'HELLO@aaronmallen.me')
context.valid? #=> false
context.success? #=> true
```

#### Context Attribute Callbacks

We can ensure only properties in the context's `attributes` are
returned after `perform` is invoked with the `clean_context_on_completion`
class method:

```ruby
class MyInteractor < ActiveInteractor::Base
  clean_context_on_completion
  context_attributes :user

  def perform
    context.user = User.create_with(
      occupation: context.occupation
    ).find_or_create_by(email: context.email)
  end
end

context = MyInteractor.perform(email: 'hello@aaronmallen.me', occupation: 'Software Dude')
context.email #=> nil
context.occupation #=> nil
context.user #=> <#User email='hello@aaronmallen.me', occupation='Software Dude'>
```

#### Perform Callbacks

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

context = MyInteractor.perform
"Start"
"Performing"
```

We can do work around `perform` invokation with the `around_perform` method:

```ruby
class MyInteractor < ActiveInteractor::Base
  context_validates :first_name, presence: true
  around_perform :track_time, if: :context_valid?

  private

  def track_time
    context.start_time = Time.now.utc
    yield
    context.end_time = Time.now.utc
  end
end

context = MyInteractor.perform(first_name: 'Aaron')
context.start_time #=> 2019-01-01 00:00:00 UTC
context.end_time #  #=> 2019-01-01 00:00:01 UTC

context = MyInteractor.perform
context.valid? #=> false
context.start_time #=> nil
context.end_time #  #=> nil
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

context = MyInteractor.perform
"Performing"
"Done"
```

#### Rollback Callbacks

We can do work before `rollback` is invoked with the `before_rollback` method:

```ruby
class MyInteractor < ActiveInteractor::Base
  before_rollback :print_start

  def rollback
    puts 'Rolling Back'
  end

  private

  def print_start
    puts 'Start'
  end
end

context = MyInteractor.perform
context.rollback!
"Start"
"Rolling Back"
```

We can do work around `rollback` invokation with the `around_rollback` method:

```ruby
class MyInteractor < ActiveInteractor::Base
  around_rollback :track_time

  private

  def track_time
    context.start_time = Time.now.utc
    yield
    context.end_time = Time.now.utc
  end
end

context = MyInteractor.perform
context.rollback!
context.start_time #=> 2019-01-01 00:00:00 UTC
context.end_time #  #=> 2019-01-01 00:00:01 UTC
```

We can do work after `rollback` is invoked with the `after_rollback` method:

```ruby
class MyInteractor < ActiveInteractor::Base
  after_rollback :print_done

  def rollback
    puts 'Rolling Back'
  end

  private

  def print_done
    puts 'Done'
  end
end

context = MyInteractor.perform
context.rollback!
"Rolling Back"
"Done"
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

given the basic interactor:

```ruby
class AuthenticateUser < ActiveInteractor::Base
  context_attributes :email, :password, :user, :token
  context_validates :email, presence: true,
                            format: { with: URI::MailTo::EMAIL_REGEXP }
  context_validates :password, presence: true
  context_validates :user, presence: true, on: :called

  def perform
    context.user = User.authenticate(
      context.email,
      context.password
    )
    context.token = context.user.secret_token
  end
end
```

The `perform` class method is the proper way to invoke an interactor.
The hash argument is converted to the interactor instance's context.
The `preform` instance method is invoked along with any callbacks and validations
that the interactor might define. Finally, the context (along with any changes made to it)
is returned.

### Kinds of Interactors

There are two kinds of interactors built into the Interactor library: basic interactors and organizers.

#### Interactors

A basic interactor is a class that includes Interactor and defines call.

```ruby
class AuthenticateUser
  include Interactor

  def perform
    if user = User.authenticate(context.email, context.password)
      context.user = user
      context.token = user.secret_token
    else
      context.fail!
    end
  end
end
```

Basic interactors are the building blocks. They are your application's single-purpose units of work.

#### Organizers

An organizer is an important variation on the basic interactor. Its single purpose is to run other interactors.

```ruby
class PlaceOrder
  include Interactor::Organizer

  organize CreateOrder, ChargeCard, SendThankYou
end
```

In the controller, you can run the `PlaceOrder` organizer just like you would any other interactor:

```ruby
class OrdersController < ApplicationController
  def create
    result = PlaceOrder.call(order_params: order_params)

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

The organizer passes its context to the interactors that it organizes, one at a time and in order.
Each interactor may change that context before it's passed along to the next interactor.

#### Rollback

If any one of the organized interactors fails its context, the organizer stops.
If the `ChargeCard` interactor fails, `SendThankYou` is never called.

In addition, any interactors that had already run are given the chance to undo themselves, in reverse order.
Simply define the rollback method on your interactors:

```ruby
class CreateOrder
  include Interactor

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
