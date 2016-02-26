# Shore::Client

Shore client to authorize API calls using [JWT](https://jwt.io)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shore-client', github: 'shore-gmbh/shore-ruby-client', tag: 'v0.1.0'
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

require 'shore/client'
Shore::Client::Tokens::AccessToken.parse_auth_header(auth_header, secret)

## Development

* Install dependencies

```sh
bin/setup
```

* Run the tests

```sh
bin/spec
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


## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/[USERNAME]/shore-ruby-client. This project is intended to
be a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

