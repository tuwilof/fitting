require 'tomogram_routing'

module Fitting
  class Documentation
    class << self
      def tomogram
        @tomogram ||= TomogramRouting::Tomogram.craft(Fitting.configuration.tomogram)
      end
    end
  end
end
