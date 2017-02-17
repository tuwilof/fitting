module Fitting
  module Storage
    module TryingTests
      class << self
        def push(test)
          @tests ||= []
          @tests.push(test)
        end

        def all
          @tests ||= []
          @tests.uniq
        end
      end
    end
  end
end
