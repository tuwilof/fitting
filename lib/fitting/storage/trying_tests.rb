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

        def routes
          routes = {}
          all.map do |response|
            if response.documented? && response.valid?
              routes[response.route] = nil
            end
          end
          routes.keys
        end
      end
    end
  end
end
