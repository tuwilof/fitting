module Fitting
  module Storage
    module Tests
      class << self
        def push(test)
          @tests ||= []
          @tests.push(location(test))
        end

        def all
          @tests ||= []
          @tests.uniq
        end

        private

        def location(date)
          name = date.inspect.to_s
          if name.split('(').size > 1
            name.split('(').last.split(')').first[2..-1]
          else
            name.split(' ')[3][2..-3]
          end
        end
      end
    end
  end
end
