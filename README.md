# Shore

Ruby client gem for the Shore APIs

[![Build Status](https://travis-ci.org/shore-gmbh/shore-ruby-client.svg?branch=master)](https://travis-ci.org/shore-gmbh/shore-ruby-client)
[![Coverage Status](https://coveralls.io/repos/github/shore-gmbh/shore-ruby-client/badge.svg?branch=master)](https://coveralls.io/github/shore-gmbh/shore-ruby-client?branch=master)
[![Code Climate](https://codeclimate.com/repos/56ddbecf41003f0085005e15/badges/242acc5710bd574a24ea/gpa.svg)](https://codeclimate.com/repos/56ddbecf41003f0085005e15/feed)
[![Issue Count](https://codeclimate.com/repos/56ddbecf41003f0085005e15/badges/242acc5710bd574a24ea/issue_count.svg)](https://codeclimate.com/repos/56ddbecf41003f0085005e15/feed)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shore', github: 'shore-gmbh/shore-ruby-client', require: 'shore/v1'
```

And then execute:

```sh
$ bundle install
```

Or install it yourself as:

```sh
$ gem install shore
```

## Usage

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

## Testing

TODO@am: Improve the documentation about how to write tests using the shore clients.

```ruby
require 'shore/webmock'
```

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/shore-gmbh/shore-ruby-client. This project is intended to
be a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
