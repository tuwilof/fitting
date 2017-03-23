require 'tomogram_routing'
require 'fitting/configuration'
require 'tomograph'

module Fitting
  module Storage
    module Documentation
      class << self
        def tomogram
          @tomogram ||= if Fitting.configuration.tomogram
            TomogramRouting::Tomogram.craft(Fitting.configuration.tomogram)
          else
            Tomograph.configure do |config|
              config.documentation = Fitting.configuration.documentation
              config.prefix = Fitting.configuration.prefix
            end
            TomogramRouting::Tomogram.craft(Tomograph::Tomogram.json)
          end
        end
      end
    end
  end
end
