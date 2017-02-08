# Fitting

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

### rspec-rails

rails_helper.rb

```ruby
require 'fitting'
config.after(:each, :type => :controller) do
  Fitting::Documentation.try_on(self, request, response)
end
```

### Formatting

```
bundle exec rspec --format Fitting::Formatter::Response::MacroYaml
```

or

```
bundle exec rspec --format Fitting::Formatter::Response::MicroYaml
```

After that you can find the report in `rreport_response_macro.yaml` or `report_response_micro.yaml`.

## Config

### tomogram

This gem takes a simplified format json convert from API Blueprint which we have called API Tomogram.

Use gem [tomograph](https://github.com/funbox/tomograph)

```ruby
  Fitting.configure do |config|
    config.tomogram = 'tomogram.json'
  end

```

### skip_not_documented

Default true.

### validation_requests

Default true.

### validation_response

Default true.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/fitting. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
