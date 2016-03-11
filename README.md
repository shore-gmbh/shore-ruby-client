# Shore::Client

Shore client to authorize API calls using [JWT](https://jwt.io)

[![Build Status](https://travis-ci.org/shore-gmbh/shore-ruby-client.svg?branch=master)](https://travis-ci.org/shore-gmbh/shore-ruby-client)
[![Coverage Status](https://coveralls.io/repos/github/shore-gmbh/shore-ruby-client/badge.svg?branch=master)](https://coveralls.io/github/shore-gmbh/shore-ruby-client?branch=master)
[![Code Climate](https://codeclimate.com/repos/56ddbecf41003f0085005e15/badges/242acc5710bd574a24ea/gpa.svg)](https://codeclimate.com/repos/56ddbecf41003f0085005e15/feed)
[![Issue Count](https://codeclimate.com/repos/56ddbecf41003f0085005e15/badges/242acc5710bd574a24ea/issue_count.svg)](https://codeclimate.com/repos/56ddbecf41003f0085005e15/feed)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shore-client', github: 'shore-gmbh/shore-ruby-client', tag: 'v0.1.1'
```

And then execute:

```sh
$ bundle install
```

Or install it yourself as:

```sh
$ gem install shore-client
```

## Usage

* Parse Authentication Header

```ruby
require 'shore-client'
Shore::Client::Tokens::AccessToken.parse_auth_header(auth_header, secret)
```

* Authentication Header format validation

```ruby
require 'shore-client'
Shore::Client::Tokens::AccessToken.valid_format?(auth_header)
```

## Development

* Install dependencies

```sh
bin/setup
```

* Run the tests

```sh
bin/rspec
```

To generate SimpleCov stats by run

```sh
COVERAGE=true bin/rspec
```

* For REPL you can use

```sh
bin/console
```

* Install the gem locally

```sh
bin/rake install
```

* Release your changes: update version number in `version.rb` file and run

```sh
gem_push=no bin/rake release
```

This will create a git tag for the version, push git commits and tags, without
pushing the gem to RubyGems.

## Use RSpec helpers in your project

To use defined jwt payload, member role and merchant account helpers in your
project, include the gem in `spec_helper.rb` like this:

```ruby
dir = Gem::Specification.find_by_name('shore-client').gem_dir
files = Dir.glob(File.join(dir, 'spec/support/*.rb'))
files.each { |f| require(f) }
```

and add this in RSpec configuration

```ruby
RSpec.configure do |config|
  config.include Shore::Client::RSpec::Helpers
end
```

For information how to use the helpers see `spec/shore/client/tokens`

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/[USERNAME]/shore-ruby-client. This project is intended to
be a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
