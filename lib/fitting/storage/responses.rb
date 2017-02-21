module Fitting
  module Storage
    module Responses
      class << self
        def push(test)
          @responses ||= []
          @responses.push(test)
        end

        def all
          @responses ||= []
          @responses.uniq
        end
      end
    end
  end
end
