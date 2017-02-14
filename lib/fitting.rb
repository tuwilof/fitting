require 'fitting/version'
require 'fitting/documentation'
require 'fitting/configuration'

module Fitting
  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end

module ActionController
  class TestCase
    module Behavior
      alias origin_process process

      def process(action, *args)
        response = origin_process(action, *args)
        double_response = response.dup
        double_response.body = MultiJson.dump(CamelCase.hash(MultiJson.load(double_response.body)))
        Fitting::Documentation.try_on(self, request, double_response)
        response
      end
    end
  end
end

module CamelCase
  class << self
    def hash(snake_case)
      snake_case.map do |key, value|
        if value.is_a?(Hash)
          [key(key), hash(value)]
        else
          [key(key), value]
        end
      end.to_h
    end

    def key(key)
      words = key.split('_').map(&:capitalize)
      words.first.downcase!
      words.join
    end
  end
end
