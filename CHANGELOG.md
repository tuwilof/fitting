# Change log

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
