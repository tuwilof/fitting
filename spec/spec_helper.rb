require 'rspec'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'
SimpleCov.start

require 'json-schema'
require 'byebug'
require 'fitting'

require 'fitting/storage/skip'

Fitting::Storage::Skip.set(true)
