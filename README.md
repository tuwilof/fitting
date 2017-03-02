# Fitting

[![Build Status](https://travis-ci.org/funbox/fitting.svg?branch=master)](https://travis-ci.org/funbox/fitting)

This gem will help to make your tests according to the documentation for the API.

When writing tests, you can be sure that the implement API in accordance with documentation on API Blueprint.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fitting'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fitting

## Usage

In your `spec_helper.rb`:

```ruby
config.include JSON::SchemaMatchers
```

This gem takes a simplified format json convert from API Blueprint which we have called API Tomogram.

Use gem [tomograph](https://github.com/funbox/tomograph)

```ruby
  Fitting.configure do |config|
    config.tomogram = 'tomogram.json'
  end

```

You can then write tests such as:

```ruby
 expect(response).to match_response
```

If you want check all tests:

```ruby
config.after(:each, :type => :controller) do
  expect(response).to match_response
end
```

## Config

### crash_not_implemented_response

Default true.

## Report

Autogenerate `report_request_by_response.yaml` and `report_response.yaml reports`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/funbox/fitting. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
