require 'tomogram_routing'

module Fitting
  module Storage
    module Documentation
      class << self
        def tomogram
          @tomogram ||= TomogramRouting::Tomogram.craft(hash)
        end

        def hash
          Fitting.configuration.tomogram
        end
      end
    end
  end
end
