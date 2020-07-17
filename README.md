# Fitting

[![Gem Version](https://badge.fury.io/rb/fitting.svg)](https://badge.fury.io/rb/fitting)
[![Build Status](https://travis-ci.org/funbox/fitting.svg?branch=master)](https://travis-ci.org/funbox/fitting)
[![Ruby](https://github.com/funbox/fitting/workflows/Ruby/badge.svg?branch=master)](https://github.com/funbox/fitting/actions?query=workflow%3ARuby)

This gem will help you implement your API in strict accordance to the documentation in [API Blueprint](https://apiblueprint.org/) format.
To do this, when you run your RSpec tests on controllers, it automatically searches for the corresponding JSON-schemas in the documentation and then validates responses with them.

## Installation

First you need to install [drafter](https://github.com/apiaryio/drafter).

Then add this line to your application's Gemfile:

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

Add this to your `.fitting.yml`:

```yaml
apib_path: /path/to/doc.apib
```

And this to your `spec_helper.rb`:

```ruby
require 'fitting'

Fitting.save_test_data
```

The result files will be created in `./fitting_tests/` folder.

Output example:

```json
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
  }
]
```

## Documentation coverage

To match routes and validate JSON-schemas run:

```bash
rake fitting:documentation_responses[report_size]
```

There are four types (or `report_size`) of reports available: 
  
- `xs` — the smallest report;
- `s` — includes coverage for `required` fields;
- `m` — includes coverage for `required` and `enum` fields;
- `l` — includes coverage for `required`, `enum` and `oneOf` fields.

E.g. for `xs` size:

```bash
rake fitting:documentation_responses[xs]
```

**Note**: In zsh you should add quotes around the task:

```bash
rake 'fitting:documentation_responses[xs]'
```

Also you can use `documentation_responses_error` to get more detailed errors description.
Check the examples below. 

### Examples

`xs` size:

```text
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

`s` size:

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

`documentation_responses_error[s]` example:

```
request method: GET
request path: /api/v1/book
response status: 200
source json-schema: {"$schema"=>"http://json-schema.org/draft-04/schema#", "type"=>"object", ...}
combination: ["required", "pages"]
new json-schema: {"$schema"=>"http://json-schema.org/draft-04/schema#", "type"=>"object", ...}
```

### Experimental report

This report will be available and properly documented in the next major update, but you already can try it by running:   

```bash
bundle e rake fitting:report
```

Using this you can document API prefixes. 
The task will create JSON (`fitting/report.json`) and HTML (`fitting/index.html`) reports.

## Tests coverage

Only `xs` size is available for tests coverage:

```bash
rake fitting:tests_responses[xs]
```

## Config

You can specify the settings either in a YAML file `.fitting.yml` or in a config.
If your project uses several prefixes, for each one you should create a separate YAML file in the folder `fitting` (`fitting/*.yml`).

All the available config options are described below.

### `apib_path`

Path to API Blueprint v3 documentation. 
There must be an installed [drafter](https://github.com/apiaryio/drafter) to parse it.

### `drafter_yaml_path`

Path to API Blueprint v3 documentation, pre-parsed with `drafter` and saved to a YAML file.

### `drafter_4_apib_path`

Path to API Blueprint v4 documentation. 
There must be an installed [drafter](https://github.com/apiaryio/drafter) to parse it.

### `drafter_4_yaml_path`

Path to API Blueprint v4 documentation, pre-parsed with `drafter` and saved to a YAML file.

### `crafter_apib_path`

Path to API Blueprint v4 documentation.

### `crafter_yaml_path`

Path to API Blueprint v4 documentation, pre-parsed with `crafter` and saved to a YAML file.

### `tomogram_json_path`

Path to Tomogram documentation, pre-parsed with [tomograph](https://github.com/funbox/tomograph) and saved to a JSON file.

### `strict`

Default: `false`

When `true` all properties are considered to have `"required": true` and all objects are considered to have `"additionalProperties": false`.

### `prefix`

Prefix for API requests. E.g. `'/api'`. Validation will not be performed if the request path does not start with a prefix.

### `white_list`

Default: all paths
 
This is an array of paths that are mandatory for implementation.
The list does not affect the work of the matcher.
It's used for the CLI report only.

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

Empty array (`[]`) means all methods.

### `resource_white_list`

Default: all resources

This is an array of resources that are mandatory for implementation.
The list does not affect the work of the matcher.
It's used for the CLI report only.

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

Empty array (`[]`) means all methods.

### `json_schema_cover`

Default: false

JSON-schema covering becomes mandatory.
However, if you don't use `Fitting.statistics` you can call `responses.statistics.cover_save`.

### `include_resources`

Default: all resources (but only when `include_resources` and `include_actions` are not defined)

This is an array of resources that are mandatory for implementation.
The list does not affect the work of the matcher.
It's used for the CLI report only.

```yaml
include_resources:
  - /sessions
```

### `include_actions`

Default: all paths (but only when `include_resources` and `include_actions` are not defined)

This is an array of paths that are mandatory for implementation.
The list does not affect the work of the matcher.
It's used for the CLI report only.

```yaml
include_actions:
  - DELETE /users/{id}
  - POST /users
  - GET /users/{id}
  - PATCH /users/{id}
  - GET /users/{id}/employees
```

### `ignore_list`

You can use ignore list to omit checks with matchers.

```yaml
ignore_list:
  - %r{/api/v1/users/[1-9].}
  - %r{/api/v1/comments}
```

It works only for `match_schema` and **not** for `strictly_match_schema`.

### `prefixes`

Example:

```yaml
prefixes:
  - name: /api/v1
  - name: /api/v2
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [github.com/funbox/fitting](https://github.com/funbox/fitting).
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[![Sponsored by FunBox](https://funbox.ru/badges/sponsored_by_funbox_centered.svg)](https://funbox.ru)
