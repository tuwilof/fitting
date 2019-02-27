# Fitting

<a href="https://funbox.ru">
  <img src="https://funbox.ru/badges/sponsored_by_funbox_compact.svg" alt="Sponsored by FunBox" width=250 />
</a>

[![Gem Version](https://badge.fury.io/rb/fitting.svg)](https://badge.fury.io/rb/fitting)
[![Build Status](https://travis-ci.org/funbox/fitting.svg?branch=master)](https://travis-ci.org/funbox/fitting)

This gem will help you implement your API in strict accordance to the documentation in [API Blueprint](https://apiblueprint.org/) format.
To do this, when you run your RSpec tests on controllers, it automatically searches for the corresponding json-schemas in the documentation and then validates responses with them.

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

In your `.fitting.yml`:

```yaml
apib_path: /path/to/doc.apib
```

In your `spec_helper.rb`:

```ruby
require 'fitting'

Fitting.save_test_data
```

The files will be created in ./fitting_tests/ path

Example:

```
[
  {
    "method": "GET",
    "path": "/api/v1/book",
    "body": {},
    "response": {
      "status": 200,
      "body": {
        "title": "The Martian Chronicles"
      }
    },
    "title": "/spec/controllers/api/v1/books_controller_spec.rb:11",
    "group": "/spec/controllers/api/v1/books_controller_spec.rb"
  },
  {
    "method": "POST",
    "path": "/api/v1/book",
    "body": {},
    "response": {
      "status": 200,
      "body": {
        "title": "The Old Man and the Sea"
      }
    },
    "title": "/spec/controllers/api/v1/books_controller_spec.rb:22",
    "group": "/spec/controllers/api/v1/books_controller_spec.rb"
  },
  ...
```


## Check documentation cover

### xs size

For match routes and valid json-schemas run `rake fitting:documentation_responses[xs]`

You will get statistics:

```
Fully conforming requests:
DELETE  /api/v1/book                 ✔ 200 ✔ 201 ✔ 404
DELETE  /api/v1/book/{id}            ✔ 200 ✔ 201 ✔ 404
GET     /api/v1/book/{id}/seller     ✔ 200 ✔ 201 ✔ 404

Partially conforming requests:
GET     /api/v1/book                 ✖ 200 ✔ 404
POST    /api/v1/book                 ✖ 200 ✔ 201 ✔ 404
GET     /api/v1/book/{id}            ✖ 200 ✔ 404 ✔ 200
PATCH   /api/v1/book/{id}            ✖ 200 ✔ 201 ✔ 404

Non-conforming requests:
GET     /api/v1/seller               ✖ 200 ✖ 201 ✖ 404
GET     /api/v1/buyer                ✖ 200 ✖ 404

API requests with fully implemented responses: 3 (33.33% of 9).
API requests with partially implemented responses: 4 (44.44% of 9).
API requests with no implemented responses: 2 (22.22% of 9).

API responses conforming to the blueprint: 16 (64.00% of 25).
API responses with validation errors or untested: 9 (36.00% of 25).
```

### s size

In addition to the previous comand, you will learn the coverage(required) json-schemas with task `rake fitting:documentation_responses[s]`

```
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

For details `rake fitting:documentation_responses_error[s]`

```
request method: GET
request path: /api/v1/book
response status: 200
source json-schema: {"$schema"=>"http://json-schema.org/draft-04/schema#", "type"=>"object", ...}
combination: ["required", "pages"]
new json-schema: {"$schema"=>"http://json-schema.org/draft-04/schema#", "type"=>"object", ...}
```

### m size

In addition to the previous comand, you will learn the coverage(enum) json-schemas with task `rake fitting:documentation_responses[m]`
For details `rake fitting:documentation_responses_error[m]`

## Check tests cover

### xs size

`rake fitting:tests_responses[xs]`

## Config

You can specify the settings either in a yaml file `.fitting.yml` or in config.
If your project uses several prefixes, for each one you need to create a separate yaml file in the folder `fitting` (`fitting/*.yml`).

### apib_path

Path to API Blueprint documentation. There must be an installed [drafter](https://github.com/apiaryio/drafter) to parse it.

### drafter_yaml_path

Path to API Blueprint documentation pre-parsed with `drafter` and saved to a YAML file.

### tomogram_json_path

Path to Tomogram documentation pre-parsed with [tomograph](https://github.com/funbox/tomograph) and saved to a JSON file.

### strict

Default `false`. If `true` then all properties are condisidered to have `"required": true` and all objects `"additionalProperties": false`.

### prefix

Prefix of API requests. Example: `'/api'`. Validation will not be performed if the request path does not start with a prefix.

### white_list

Default: all paths. This is an array of paths that are mandatory for implementation.
This list does not affect the work of the matcher.
This list is only for the report in the console.

```yaml
white_list:
  /users:
    - DELETE
    - POST
  /users/{id}:
    - GET
    - PATCH
  /users/{id}/employees:
    - GET
  /sessions: []
```

Empty array `[]` means all methods.

### resource_white_list

Default: all resources. This is an array of resources that are mandatory for implementation.
This list does not affect the work of the matcher.
This list is only for the report in the console.

```yaml
resource_white_list:
  /users:
    - DELETE /users/{id}
    - POST /users
    - GET /users/{id}
    - PATCH /users/{id}
  /users/{id}/employees:
    - GET /users/{id}/employees
  /sessions: []
```

Empty array `[]` means all methods.

### json_schema_cover

Default: false. Json-schema covering becomes mandatory.
Or you can call `responses.statistics.cover_save` if you don't use call `Fitting.statistics`.

### include_resources

Default: all resources if  `include_resources` and `include_actions` is not used.
This is an array of resources that are mandatory for implementation.
This list does not affect the work of the matcher.
This list is only for the report in the console.

```yaml
include_resources:
  - /sessions
```

### include_actions

Default: all paths if `include_resources` and `include_actions` is not used.
This is an array of paths that are mandatory for implementation.
This list does not affect the work of the matcher.
This list is only for the report in the console.

```yaml
include_actions:
  - DELETE /users/{id}
  - POST /users
  - GET /users/{id}
  - PATCH /users/{id}
  - GET /users/{id}/employees
```

### ignore_list

You can use ignore list for omit checks with matchers.

```yaml
ignore_list:
  - %r{/api/v1/users/[1-9].}
  - %r{/api/v1/comments}
```

It works only for match_schema (NOT FOR strictly_match_schema)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/funbox/fitting. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
