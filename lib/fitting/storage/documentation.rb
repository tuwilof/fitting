require 'tomogram_routing'
require 'fitting/configuration'
require 'tomograph'

module Fitting
  module Storage
    module Documentation
      class << self
        def tomogram
          @tomogram ||= craft
        end

        def craft
          Tomograph::Tomogram.new(
            apib_path: Fitting.configuration.apib_path,
            drafter_yaml_path: Fitting.configuration.drafter_yaml_path,
            prefix: Fitting.configuration.prefix
          )
        end
      end
    end
  end
end
