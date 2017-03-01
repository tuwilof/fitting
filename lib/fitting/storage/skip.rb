module Fitting
  module Storage
    module Skip
      class << self
        def set(skip)
          @skip = skip
        end

        def get
          @skip ||= false
        end
      end
    end
  end
end
