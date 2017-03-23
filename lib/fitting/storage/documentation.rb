require 'tomogram_routing'
require 'fitting/configuration'
require 'tomograph'

module Fitting
  module Storage
    module Documentation
      class << self
        def tomogram
          @tomogram ||= if Fitting.configuration.apib_path
            @yaml ||= `drafter #{Fitting.configuration.apib_path}`
            Tomograph.configure do |config|
              config.drafter_yaml = @yaml
              config.prefix = Fitting.configuration.prefix
            end
            TomogramRouting::Tomogram.craft(Tomograph::Tomogram.json)
          elsif Fitting.configuration.tomogram
            # legacy
            TomogramRouting::Tomogram.craft(Fitting.configuration.tomogram)
          else
            Tomograph.configure do |config|
              config.documentation = Fitting.configuration.drafter_yaml_path
              config.prefix = Fitting.configuration.prefix
            end
            TomogramRouting::Tomogram.craft(Tomograph::Tomogram.json)
          end
        end
      end
    end
  end
end
