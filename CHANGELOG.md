# Change log

### x.y.z - yyyy-mm-dd

* features
  * color for bad response [#79](https://github.com/funbox/fitting/issues/79)

### 2.14.1 - 2020-09-23

* fixes
  * fix directory error [#75](https://github.com/funbox/fitting/issues/75)
  * upgrade node-forge [#77](https://github.com/funbox/fitting/issues/77)

### 2.14.0 - 2020-09-18

* features
  * save tests for all prefixes [#35](https://github.com/funbox/fitting/issues/35)
  * prefix checking [#37](https://github.com/funbox/fitting/issues/37)
  * html view for prefix checking [#39](https://github.com/funbox/fitting/issues/39)
  * add actions join in new html report [#41](https://github.com/funbox/fitting/issues/41)
  * add responses join in new report [#43](https://github.com/funbox/fitting/issues/43)
  * add combinations join in new report [#47](https://github.com/funbox/fitting/issues/47)
  * add action page [#49](https://github.com/funbox/fitting/issues/49)
  * show more information in new report [#51](https://github.com/funbox/fitting/issues/51)
  * add accordion for prefixes [#55](https://github.com/funbox/fitting/issues/55)
  * move json-schemas to separate files [#57](https://github.com/funbox/fitting/issues/57)
  * add method for tests without actions [#61](https://github.com/funbox/fitting/issues/61)
  * show tests without responses [#63](https://github.com/funbox/fitting/issues/63)
  * add console output for new report [#69](https://github.com/funbox/fitting/issues/69)
  * check test in new console [#71](https://github.com/funbox/fitting/issues/71)
* fixes
  * fix vulnerability CVE-2020-7660 [#53](https://github.com/funbox/fitting/issues/53)
  * fix cover if response without combinations [#59](https://github.com/funbox/fitting/issues/59)
  * fix cover if combinations without tests [#66](https://github.com/funbox/fitting/issues/66)
  * do not check tests without combinations [#73](https://github.com/funbox/fitting/issues/73)

### 2.13.1 - 2020-04-17

* fixes
  * combinations

### 2.13.0 - 2020-02-26

* features
  * use request tests

* patch
  * improve combination name for enum cover
  * improve combination name for required cover

### 2.12.1 - 2020-02-07

* fixes
  * oneOf

### 2.12.0 - 2019-09-10

* features
  * Add l size (for cover oneOf in json-schema) in rake tasks fitting:documentation_responses, fitting:documentation_responses_error

### 2.11.0 - 2019-09-09

* features
 * crafter_apib_path
 * drafter_4_apib_path
 * drafter_4_yaml_path

* fixes
  * crafter_yaml_path

### 2.10.0 - 2019-09-05

* features
  * add crafter_yaml_path

### 2.9.1 - 2019-07-15

* fixes
  * Improve gemspec
  * Delete experimental code with haml

### 2.9.0 - 2019-07-15

* features
  * Delete old spec json
* fixes
  * Improve gemspec

### 2.8.1 - 2018-12-18

* features
  * Add support for [parallel_tests](https://github.com/grosser/parallel_tests)

### 2.8.0 - 2018-10-13

* features
  * Add m size (for cover enum in json-schema) in rake tasks fitting:documentation_responses, fitting:documentation_responses_error

### 2.7.2 - 2018-09-08

* fixes
  * Output full combination key in fitting:documentation_responses_error

### 2.7.1 - 2018-09-06

* fixes
  * Output fitting:documentation_responses_error if not all covered

### 2.7.0 - 2018-09-04

* features
  * Add three rake tasks fitting:documentation_responses, fitting:documentation_responses_error and fitting:tests_responses

### 2.6.0 - 2018-08-28

* features
  * Add two rake tasks fitting:documentation and fitting:tests

### 2.5.0 - 2018-07-05

* features
  * Add Tomograph JSON support

### 2.4.1 - 2018-03-16

* fixes
  * update runtime dependency tomograph

### 2.4.0 - 2018-02-05

* features
  * add include_resources and include_actions configs
* deprecations
  * white_list and resource_white_list configs
  * configure

### 2.3.0 - 2017-09-13

* features
  * configuration via yaml file
  * setting for multiple prefixes

### 2.2.0 - 2017-08-23

* features
  * ignore requests which match with ignore list

### 2.1.3 - 2017-08-07

* fixes
  * does not raise an exception if the whitelist is not used

### 2.1.2 - 2017-07-04

* fixes
  * one response may match with more than one scheme
  * inform non-existent resources in the white list of resources

### 2.1.1 - 2017-06-22

* fixes
  * work correctly everywhere, not just in controller tests

### 2.1.0 - 2017-06-19

* features
  * add resource_white_list config

### 2.0.3 - 2017-05-02

* fixes
  * skip expect if prefix not match

### 2.0.2 - 2017-05-02

* fixes
  * validate html response
