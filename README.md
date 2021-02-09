# Fitting

Coverage API Blueprint, Swagger and OpenAPI with rspec tests for easily make high-quality.

![exmaple](example.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fitting'
```

After that execute:

```bash
$ bundle
```

Or install the gem by yourself:

```bash
$ gem install fitting
```

## Usage
And next to your `spec_helper.rb`:

```ruby
require 'fitting'

Fitting.save_test_data
```

Add this to your `.fitting.yml`:

### OpenAPI 2.0
Also Swagger

```yaml
prefixes:
  - name: /api/v1
    openapi2_json_path: doc.json
```

### OpenAPI 3.0
Also OpenAPI

```yaml
prefixes:
  - name: /api/v1
    openapi3_yaml_path: doc.yaml
```

### API Blueprint
First you need to install [drafter](https://github.com/apiaryio/drafter).
Works after conversion from API Blueprint to API Elements (in YAML file) with Drafter.

That is, I mean that you first need to do this

```bash
drafter doc.apib -o doc.yaml
```

and then

```yaml
prefixes:
  - name: /api/v1
    drafter_yaml_path: doc.yaml
```

### Tomograph

To use additional features of the pre-converted [tomograph](https://github.com/funbox/tomograph)

```yaml
prefixes:
  - name: /api/v1
    tomogram_json_path: doc.json
```

## Run
```bash
bundle e rake fitting:report
```

Console ouptut

```text
Fully conforming requests:
DELETE  /api/v1/book                 100% 200 100% 201 100% 404
DELETE  /api/v1/book/{id}            100% 200 100% 201 100% 404
GET     /api/v1/book/{id}/seller     100% 200 100% 201 100% 404

Partially conforming requests:
GET     /api/v1/book                 0% 200 66% 404
POST    /api/v1/book                 0% 200 90% 201 100% 404
GET     /api/v1/book/{id}            0% 200 88% 404 10% 200
PATCH   /api/v1/book/{id}            0% 200 100% 201 10% 404

Non-conforming requests:
GET     /api/v1/seller               0% 200 0% 201 0 404
GET     /api/v1/buyer                0% 200 0% 404

API requests with fully implemented responses: 3 (33.33% of 9).
API requests with partially implemented responses: 4 (44.44% of 9).
API requests with no implemented responses: 2 (22.22% of 9).

API responses conforming to the blueprint: 16 (64.00% of 25).
API responses with validation errors or untested: 9 (36.00% of 25).
```

And task will create HTML (`fitting/index.html`) reports.

![exmaple](example.png)

## Contributing

Bug reports and pull requests are welcome on GitHub at [github.com/funbox/fitting](https://github.com/funbox/fitting).
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[![Sponsored by FunBox](https://funbox.ru/badges/sponsored_by_funbox_centered.svg)](https://funbox.ru)
