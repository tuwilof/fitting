require 'tomogram_routing'
require 'fitting/configuration'

module Fitting
  module Storage
    module Documentation
      class << self
        def tomogram
          @tomogram ||= TomogramRouting::Tomogram.craft(Fitting.configuration.tomogram)
        end
      end
    end
  end
end
